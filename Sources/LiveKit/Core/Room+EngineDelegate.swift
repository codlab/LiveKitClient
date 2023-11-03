/*
 * Copyright 2023 LiveKit
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

@_implementationOnly import WebRTC

extension Room: EngineDelegate {

    func engine(_ engine: Engine, didMutate state: Engine.State, oldState: Engine.State) {

        if state.connectionState != oldState.connectionState {
            // connectionState did update

            // only if quick-reconnect
            if case .connected = state.connectionState, case .quick = state.reconnectMode {

                resetTrackSettings()
            }

            // Re-send track permissions
            if case .connected = state.connectionState, let localParticipant = localParticipant {
                Task {
                    do {
                        try await localParticipant.sendTrackSubscriptionPermissions()
                    } catch let error {
                        log("Failed to send track subscription permissions, error: \(error)", .error)
                    }
                }
            }

            delegates.notify(label: { "room.didUpdate connectionState: \(state.connectionState) oldValue: \(oldState.connectionState)" }) {
                // Objective-C support
                $0.room?(self, didUpdate: state.connectionState.toObjCType(), oldValue: oldState.connectionState.toObjCType())
                // Swift only
                if let delegateSwift = $0 as? RoomDelegate {
                    delegateSwift.room(self, didUpdate: state.connectionState, oldValue: oldState.connectionState)
                }
            }

            // Legacy connection delegates
            if case .connected = state.connectionState {
                let didReconnect = oldState.connectionState == .reconnecting
                delegates.notify { $0.room?(self, didConnect: didReconnect) }
            } else if case .disconnected(let reason) = state.connectionState {
                if case .connecting = oldState.connectionState {
                    let error = reason?.networkError ?? NetworkError.disconnected(message: "Did fail to connect", rawError: nil)
                    delegates.notify { $0.room?(self, didFailToConnect: error) }
                } else {
                    delegates.notify { $0.room?(self, didDisconnect: reason?.networkError) }
                }
            }
        }

        if state.connectionState.isReconnecting && state.reconnectMode == .full && oldState.reconnectMode != .full {
            Task {
                // Started full reconnect
                await cleanUpParticipants(notify: true)
            }
        }

        // Notify change when engine's state mutates
        Task.detached { @MainActor in
            self.objectWillChange.send()
        }
    }

    func engine(_ engine: Engine, didUpdate speakers: [Livekit_SpeakerInfo]) {

        let activeSpeakers = _state.mutate { state -> [Participant] in

            var activeSpeakers: [Participant] = []
            var seenSids = [String: Bool]()
            for speaker in speakers {
                seenSids[speaker.sid] = true
                if let localParticipant = state.localParticipant,
                   speaker.sid == localParticipant.sid {
                    localParticipant._state.mutate {
                        $0.audioLevel = speaker.level
                        $0.isSpeaking = true
                    }
                    activeSpeakers.append(localParticipant)
                } else {
                    if let participant = state.remoteParticipants[speaker.sid] {
                        participant._state.mutate {
                            $0.audioLevel = speaker.level
                            $0.isSpeaking = true
                        }
                        activeSpeakers.append(participant)
                    }
                }
            }

            if let localParticipant = state.localParticipant, seenSids[localParticipant.sid] == nil {
                localParticipant._state.mutate {
                    $0.audioLevel = 0.0
                    $0.isSpeaking = false
                }
            }

            for participant in state.remoteParticipants.values {
                if seenSids[participant.sid] == nil {
                    participant._state.mutate {
                        $0.audioLevel = 0.0
                        $0.isSpeaking = false
                    }
                }
            }

            return activeSpeakers
        }

        engine.executeIfConnected { [weak self] in
            guard let self = self else { return }

            self.delegates.notify(label: { "room.didUpdate speakers: \(activeSpeakers)" }) {
                $0.room?(self, didUpdate: activeSpeakers)
            }
        }
    }

    func engine(_ engine: Engine, didAddTrack track: LKRTCMediaStreamTrack, rtpReceiver: LKRTCRtpReceiver, streams: [LKRTCMediaStream]) {

        guard !streams.isEmpty else {
            log("Received onTrack with no streams!", .warning)
            return
        }

        let unpacked = streams[0].streamId.unpack()
        let participantSid = unpacked.sid
        var trackSid = unpacked.trackId
        if trackSid == "" {
            trackSid = track.trackId
        }

        let participant = _state.mutate { $0.getOrCreateRemoteParticipant(sid: participantSid, room: self) }

        log("added media track from: \(participantSid), sid: \(trackSid)")

        let task = Task.retrying(retryDelay: 0.2) { _, _ in
            // TODO: Only retry for TrackError.state = error
            try await participant.addSubscribedMediaTrack(rtcTrack: track, rtpReceiver: rtpReceiver, sid: trackSid)
        }

        Task {
            try await task.value
        }
    }

    func engine(_ engine: Engine, didRemove track: LKRTCMediaStreamTrack) {
        // find the publication
        guard let publication = _state.remoteParticipants.values.map({ $0._state.tracks.values }).joined()
                .first(where: { $0.sid == track.trackId }) else { return }
        publication.set(track: nil)
    }

    func engine(_ engine: Engine, didReceive userPacket: Livekit_UserPacket) {
        // participant could be null if data broadcasted from server
        let participant = _state.remoteParticipants[userPacket.participantSid]

        engine.executeIfConnected { [weak self] in
            guard let self = self else { return }

            self.delegates.notify(label: { "room.didReceive data: \(userPacket.payload)" }) {
                $0.room?(self, participant: participant, didReceiveData: userPacket.payload, topic: userPacket.topic)
            }

            if let participant = participant {
                participant.delegates.notify(label: { "participant.didReceive data: \(userPacket.payload)" }) { [weak participant] (delegate) -> Void in
                    guard let participant = participant else { return }
                    delegate.participant?(participant, didReceiveData: userPacket.payload, topic: userPacket.topic)
                }
            }
        }
    }
}
