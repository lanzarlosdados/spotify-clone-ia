import Foundation

// MARK: - PlayerCompositionRoot
/// Composition Root for the Player feature.
/// Creates and wires all dependencies following the Dependency Injection pattern.
final class PlayerCompositionRoot {

    // MARK: - Singleton

    static let shared = PlayerCompositionRoot()

    /// Shared, app-wide playback engine. Playlist (and any future "now playing" bar)
    /// drive playback through this instance.
    let playbackController = PlaybackController()

    private init() {
        print("🏗️ PlayerCompositionRoot: Initialized.")
    }

    // MARK: - Factory Methods

    func makePlayerViewModel() -> PlayerViewModel {
        PlayerViewModel(
            controller: playbackController,
            getCurrentlyPlayingTrackUseCase: GetCurrentlyPlayingTrackUseCase(playerRepository: makeRepository())
        )
    }

    /// Creates the repository implementation.
    /// Currently returns a mock-backed repository for development.
    /// TODO: Replace with a real API repository when the backend is ready.
    private func makeRepository() -> PlayerRepositoryProtocol {
        DefaultPlayerRepository(dataSource: MockPlayerDataSource())
    }

    // MARK: - Testing Support

    /// Creates a `PlayerViewModel` with a custom repository (and optionally a fresh
    /// controller) for testing.
    static func makePlayerViewModel(
        with repository: PlayerRepositoryProtocol,
        controller: PlaybackController = PlaybackController()
    ) -> PlayerViewModel {
        PlayerViewModel(
            controller: controller,
            getCurrentlyPlayingTrackUseCase: GetCurrentlyPlayingTrackUseCase(playerRepository: repository)
        )
    }
}

// MARK: - Convenience Extension

extension PlayerCompositionRoot {

    /// Creates a fully configured `PlayerView`.
    func makePlayerView() -> PlayerView {
        PlayerView(viewModel: makePlayerViewModel())
    }
}
