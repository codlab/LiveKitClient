import Foundation

public class ParticipantDelegateKotlin: ParticipantDelegate {
    var delegate : ParticipantDelegate

    public init (delegate: ParticipantDelegate) {
        self.delegate = delegate
    }

    // MARK: - Participant

    /// A ``Participant``'s metadata has updated.
    /// `participant` Can be a ``LocalParticipant`` or a ``RemoteParticipant``.
    @objc
    public func participant(_ participant: Participant, didUpdateMetadata metadata: String?) {
        self.delegate.participant?(participant, didUpdateMetadata: metadata)
    }

    /// A ``Participant``'s name has updated.
    /// `participant` Can be a ``LocalParticipant`` or a ``RemoteParticipant``.
    @objc
    public func participant(_ participant: Participant, didUpdateName name: String) {
        self.delegate.participant?(participant, didUpdateName: name)
    }

    /// The isSpeaking status of a ``Participant`` has changed.
    /// `participant` Can be a ``LocalParticipant`` or a ``RemoteParticipant``.
    @objc
    public func participant(_ participant: Participant, didUpdateIsSpeaking isSpeaking: Bool) {
        print("in the wrapper for is speaking \(type(of: self.delegate))")
        self.delegate.participant?(participant, didUpdateIsSpeaking: isSpeaking)
    }

    /// The connection quality of a ``Participant`` has updated.
    /// `participant` Can be a ``LocalParticipant`` or a ``RemoteParticipant``.
    @objc
    public func participant(_ participant: Participant, didUpdateConnectionQuality connectionQuality: ConnectionQuality) {
        self.delegate.participant?(participant, didUpdateConnectionQuality: connectionQuality)
    }

    @objc
    public func participant(_ participant: Participant, didUpdatePermissions permissions: ParticipantPermissions) {
        self.delegate.participant?(participant, didUpdatePermissions: permissions)
    }

    // MARK: - TrackPublication

    /// `muted` state has updated for the ``Participant``'s ``TrackPublication``.
    ///
    /// For the ``LocalParticipant``, the delegate method will be called if setMute was called on ``LocalTrackPublication``,
    /// or if the server has requested the participant to be muted.
    ///
    /// `participant` Can be a ``LocalParticipant`` or a ``RemoteParticipant``.
    @objc
    public func participant(_ participant: Participant, trackPublication: TrackPublication, didUpdateIsMuted isMuted: Bool) {
        self.delegate.participant?(participant, trackPublication: trackPublication, didUpdateIsMuted: isMuted)
    }

    // MARK: - LocalTrackPublication

    /// The ``LocalParticipant`` has published a ``LocalTrackPublication``.
    @objc(localParticipant:didPublishTrack:)
    public func participant(_ participant: LocalParticipant, didPublishTrack publication: LocalTrackPublication) {
        self.delegate.participant?(participant, didPublishTrack: publication)
    }

    /// The ``LocalParticipant`` has unpublished a ``LocalTrackPublication``.
    @objc(localParticipant:didUnpublishTrack:)
    public func participant(_ participant: LocalParticipant, didUnpublishTrack publication: LocalTrackPublication) {
        self.delegate.participant?(participant, didUnpublishTrack: publication)
    }

    // MARK: - RemoteTrackPublication

    /// When a new ``RemoteTrackPublication`` is published to ``Room`` after the ``LocalParticipant`` has joined.
    ///
    /// This delegate method will not be called for tracks that are already published.
    @objc(remoteParticipant:didPublishTrack:)
    public func participant(_ participant: RemoteParticipant, didPublishTrack publication: RemoteTrackPublication) {
        self.delegate.participant?(participant, didPublishTrack: publication)
    }

    /// The ``RemoteParticipant`` has unpublished a ``RemoteTrackPublication``.
    @objc(remoteParticipant:didUnpublishTrack:)
    public func participant(_ participant: RemoteParticipant, didUnpublishTrack publication: RemoteTrackPublication) {
        self.delegate.participant?(participant, didUnpublishTrack: publication)
    }

    /// The ``LocalParticipant`` has subscribed to a new ``RemoteTrackPublication``.
    ///
    /// This event will always fire as long as new tracks are ready for use.
    @objc
    public func participant(_ participant: RemoteParticipant, didSubscribeTrack publication: RemoteTrackPublication) {
        self.delegate.participant?(participant, didSubscribeTrack: publication)
    }

    /// Unsubscribed from a ``RemoteTrackPublication`` and  is no longer available.
    ///
    /// Clients should listen to this event and handle cleanup.
    @objc
    public func participant(_ participant: RemoteParticipant, didUnsubscribeTrack publication: RemoteTrackPublication) {
        self.delegate.participant?(participant, didUnsubscribeTrack: publication)
    }

    /// Could not subscribe to a track.
    ///
    /// This is an error state, the subscription can be retried.
    @objc
    public func participant(_ participant: RemoteParticipant, didFailToSubscribeTrackWithSid trackSid: Track.Sid, error: LiveKitError) {
        self.delegate.participant?(participant, didFailToSubscribeTrackWithSid: trackSid, error: error)
    }

    /// ``TrackPublication/streamState`` has updated for the ``RemoteTrackPublication``.
    @objc
    public func participant(_ participant: RemoteParticipant, trackPublication: RemoteTrackPublication, didUpdateStreamState streamState: StreamState) {
        self.delegate.participant?(participant, trackPublication: trackPublication, didUpdateStreamState: streamState)
    }

    /// ``RemoteTrackPublication/isSubscriptionAllowed`` has updated for the ``RemoteTrackPublication``.
    @objc
    public func participant(_ participant: RemoteParticipant, trackPublication: RemoteTrackPublication, didUpdateIsSubscriptionAllowed isSubscriptionAllowed: Bool) {
        self.delegate.participant?(participant, trackPublication: trackPublication, didUpdateIsSubscriptionAllowed: isSubscriptionAllowed)
    }

    // MARK: - Data

    /// Data was received from a ``RemoteParticipant``.
    @objc
    public func participant(_ participant: RemoteParticipant, didReceiveData data: Data, forTopic topic: String) {
        self.delegate.participant?(participant, didReceiveData: data, forTopic: topic)
    }
}