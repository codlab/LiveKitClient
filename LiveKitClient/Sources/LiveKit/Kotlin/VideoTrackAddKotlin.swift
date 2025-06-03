import Foundation

@objc
public class VideoTrackAddKotlin: NSObject {
    var videoView : VideoView

    public init (videoView: VideoView) {
        self.videoView = videoView
    }

    @objc(addRemote:)
    public func add(remoteVideoTrack track: RemoteVideoTrack) {
        self.videoView.track = track
    }

    @objc(addLocal:)
    public func add(localVideoTrack track: LocalVideoTrack) {
        self.videoView.track = track
    }

    @objc(removeRemote:)
    public func remove(remoteVideoTrack track: RemoteVideoTrack) {
        self.videoView.track = nil
    }

    @objc(removeLocal:)
    public func remove(localVideoTrack track: LocalVideoTrack) {
        self.videoView.track = nil
    }
}