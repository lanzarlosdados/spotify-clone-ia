import Foundation

// MARK: - PlayerViewModel
/// View model for the full-screen Player. Exposes display-ready state derived from
/// the shared `PlaybackController` and forwards user intent back to it.
@Observable
final class PlayerViewModel {

    // MARK: - Dependencies

    private let controller: PlaybackController
    private let getCurrentlyPlayingTrackUseCase: GetCurrentlyPlayingTrackUseCase

    // MARK: - Own state

    var errorMessage: String?

    // MARK: - Init

    init(controller: PlaybackController, getCurrentlyPlayingTrackUseCase: GetCurrentlyPlayingTrackUseCase) {
        self.controller = controller
        self.getCurrentlyPlayingTrackUseCase = getCurrentlyPlayingTrackUseCase
        print("🎯 PlayerViewModel: Initialized.")
    }

    // MARK: - Derived display state

    var track: Track? { controller.currentTrack }
    var contextLabel: String { controller.context.isEmpty ? "PLAYING" : controller.context }
    var contextTitle: String { controller.contextTitle }
    var isPlaying: Bool { controller.state.isPlaying }
    var isShuffled: Bool { controller.state.isShuffled }
    var repeatMode: RepeatMode { controller.state.repeatMode }
    var isLiked: Bool { controller.isCurrentTrackLiked }

    private var positionSeconds: Double { controller.state.positionSeconds }
    private var durationSeconds: Double { Double(controller.currentTrack?.durationSeconds ?? 0) }

    var progress: Double {
        guard durationSeconds > 0 else { return 0 }
        return min(max(0, positionSeconds / durationSeconds), 1)
    }

    var elapsedText: String { Self.timeString(positionSeconds) }
    var durationText: String { Self.timeString(durationSeconds) }

    // MARK: - Lifecycle

    /// Ensures there is a track to show. If the player was opened cold (no queue),
    /// fetches the "currently playing" track from the repository as a fallback.
    func load() async {
        guard controller.currentTrack == nil else { return }

        print("🔄 PlayerViewModel: No active queue, fetching fallback track...")
        do {
            let track = try await getCurrentlyPlayingTrackUseCase.execute()
            await MainActor.run { controller.seedIfNeeded(with: track) }
            print("✅ PlayerViewModel: Seeded with '\(track.title)'.")
        } catch {
            await MainActor.run { errorMessage = error.localizedDescription }
            print("❌ PlayerViewModel: Error loading fallback track - \(error.localizedDescription)")
        }
    }

    // MARK: - Intent

    func togglePlayPause() { controller.togglePlayPause() }
    func next() { controller.next() }
    func previous() { controller.previous() }
    func toggleShuffle() { controller.toggleShuffle() }
    func cycleRepeat() { controller.cycleRepeat() }
    func toggleLike() { controller.toggleLike() }

    /// `fraction` is 0...1 along the seek bar.
    func seek(toFraction fraction: Double) {
        controller.seek(to: fraction * durationSeconds)
    }

    // MARK: - Helpers

    static func timeString(_ seconds: Double) -> String {
        let total = max(0, Int(seconds.rounded()))
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}
