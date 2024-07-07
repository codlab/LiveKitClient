import Foundation

public class RoomDelegateKotlin: RoomDelegate {
    var delegate : RoomDelegate

    public init (delegate: RoomDelegate) {
        self.delegate = delegate
    }

    // MARK: - Connection Events

    /// ``Room/connectionState`` has updated.
    @objc
    public func room(_ room: Room, didUpdateConnectionState connectionState: ConnectionState, from oldConnectionState: ConnectionState) {
        self.delegate.room?(room, didUpdateConnectionState: connectionState, from: oldConnectionState)
    }

    /// Successfully connected to the room.
    @objc
    public func roomDidConnect(_ room: Room) {
        self.delegate.roomDidConnect?(room)
    }

    /// Previously connected to room but re-attempting to connect due to network issues.
    @objc
    public func roomIsReconnecting(_ room: Room) {
        self.delegate.roomIsReconnecting?(room)
    }

    /// Successfully re-connected to the room.
    @objc
    public func roomDidReconnect(_ room: Room) {
        self.delegate.roomDidReconnect?(room)
    }

    /// Could not connect to the room. Only triggered when the initial connect attempt fails.
    @objc
    public func room(_ room: Room, didFailToConnectWithError error: LiveKitError?) {
        self.delegate.room?(room, didFailToConnectWithError: error)
    }

    /// Client disconnected from the room unexpectedly after a successful connection.
    @objc
    public func room(_ room: Room, didDisconnectWithError error: LiveKitError?) {
        self.delegate.room?(room, didDisconnectWithError: error)
    }

    // MARK: - Room State Updates

    /// ``Room/metadata`` has updated.
    @objc
    public func room(_ room: Room, didUpdateMetadata metadata: String?) {
        self.delegate.room?(room, didUpdateMetadata: metadata)
    }

    /// ``Room/isRecording`` has updated.
    @objc
    public func room(_ room: Room, didUpdateIsRecording isRecording: Bool) {
        self.delegate.room?(room, didUpdateIsRecording: isRecording)
    }

    // MARK: - Participant Management

    /// A ``RemoteParticipant`` joined the room.
    @objc
    public func room(_ room: Room, participantDidConnect participant: RemoteParticipant) {
        self.delegate.room?(room, participantDidConnect: participant)
    }

    /// A ``RemoteParticipant`` left the room.
    @objc
    public func room(_ room: Room, participantDidDisconnect participant: RemoteParticipant) {
        self.delegate.room?(room, participantDidDisconnect: participant)
    }

    /// Speakers in the room has updated.
    @objc
    public func room(_ room: Room, didUpdateSpeakingParticipants participants: [Participant]) {
        self.delegate.room?(room, didUpdateSpeakingParticipants: participants)
    }

    /// ``Participant/metadata`` has updated.
    @objc
    public func room(_ room: Room, participant: Participant, didUpdateMetadata metadata: String?) {
        self.delegate.room?(room, participant: participant, didUpdateMetadata: metadata)
    }

    /// ``Participant/name`` has updated.
    @objc
    public func room(_ room: Room, participant: Participant, didUpdateName name: String) {
        self.delegate.room?(room, participant: participant, didUpdateName: name)
    }

    /// ``Participant/connectionQuality`` has updated.
    @objc
    public func room(_ room: Room, participant: Participant, didUpdateConnectionQuality quality: ConnectionQuality) {
        self.delegate.room?(room, participant: participant, didUpdateConnectionQuality: quality)
    }

    /// ``Participant/permissions`` has updated.
    @objc
    public func room(_ room: Room, participant: Participant, didUpdatePermissions permissions: ParticipantPermissions) {
        self.delegate.room?(room, participant: participant, didUpdatePermissions: permissions)
    }

    // MARK: - Track Publications

    /// The ``LocalParticipant`` has published a ``LocalTrack``.
    @objc(room:localParticipant:didPublishTrack:)
    public func room(_ room: Room, participant: LocalParticipant, didPublishTrack publication: LocalTrackPublication) {
        self.delegate.room?(room, participant: participant, didPublishTrack: publication)
    }

    /// A ``RemoteParticipant`` has published a ``RemoteTrack``.
    @objc(room:remoteParticipant:didPublishTrack:)
    public func room(_ room: Room, participant: RemoteParticipant, didPublishTrack publication: RemoteTrackPublication) {
        self.delegate.room?(room, participant: participant, didPublishTrack: publication)
    }

    /// The ``LocalParticipant`` has un-published a ``LocalTrack``.
    @objc(room:localParticipant:didUnpublishTrack:)
    public func room(_ room: Room, participant: LocalParticipant, didUnpublishTrack publication: LocalTrackPublication) {
        self.delegate.room?(room, participant: participant, didUnpublishTrack: publication)
    }

    /// A ``RemoteParticipant`` has un-published a ``RemoteTrack``.
    @objc(room:remoteParticipant:didUnpublishTrack:)
    public func room(_ room: Room, participant: RemoteParticipant, didUnpublishTrack publication: RemoteTrackPublication) {
        self.delegate.room?(room, participant: participant, didUnpublishTrack: publication)
    }

    @objc
    public func room(_ room: Room, participant: RemoteParticipant, didSubscribeTrack publication: RemoteTrackPublication) {
        self.delegate.room?(room, participant: participant, didSubscribeTrack: publication)
    }

    @objc
    public func room(_ room: Room, participant: RemoteParticipant, didUnsubscribeTrack publication: RemoteTrackPublication) {
        self.delegate.room?(room, participant: participant, didUnsubscribeTrack: publication)
    }

    @objc
    public func room(_ room: Room, participant: RemoteParticipant, didFailToSubscribeTrackWithSid trackSid: Track.Sid, error: LiveKitError) {
        self.delegate.room?(room, participant: participant, didFailToSubscribeTrackWithSid: trackSid, error: error)
    }

    // MARK: - Data and Encryption

    /// Received data from from a user or server. `participant` will be nil if broadcasted from server.
    @objc
    public func room(_ room: Room, participant: RemoteParticipant?, didReceiveData data: Data, forTopic topic: String) {
        self.delegate.room?(room, participant: participant, didReceiveData: data, forTopic: topic)
    }

    @objc
    public func room(_ room: Room, trackPublication: TrackPublication, didUpdateE2EEState state: E2EEState) {
        self.delegate.room?(room, trackPublication: trackPublication, didUpdateE2EEState: state)
    }

    /// ``TrackPublication/isMuted`` has updated.
    @objc
    public func room(_ room: Room, participant: Participant, trackPublication: TrackPublication, didUpdateIsMuted isMuted: Bool) {
        self.delegate.room?(room, participant: participant, trackPublication: trackPublication, didUpdateIsMuted: isMuted)
    }

    /// ``TrackPublication/streamState`` has updated.
    @objc
    public func room(_ room: Room, participant: RemoteParticipant, trackPublication: RemoteTrackPublication, didUpdateStreamState streamState: StreamState) {
        self.delegate.room?(room, participant: participant, trackPublication: trackPublication, didUpdateStreamState: streamState)
    }

    /// ``RemoteTrackPublication/isSubscriptionAllowed`` has updated.
    @objc
    public func room(_ room: Room, participant: RemoteParticipant, trackPublication: RemoteTrackPublication, didUpdateIsSubscriptionAllowed isSubscriptionAllowed: Bool) {
        self.delegate.room?(room, participant: participant, trackPublication: trackPublication, didUpdateIsSubscriptionAllowed: isSubscriptionAllowed)
    }
}