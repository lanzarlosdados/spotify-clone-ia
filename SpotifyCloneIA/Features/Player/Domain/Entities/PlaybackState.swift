import Foundation

// MARK: - PlaybackState
/// Transient state of the playback engine for the current track.
struct PlaybackState: Equatable {
    var isPlaying: Bool = false
    var positionSeconds: Double = 0
    var isShuffled: Bool = false
    var repeatMode: RepeatMode = .off
}
