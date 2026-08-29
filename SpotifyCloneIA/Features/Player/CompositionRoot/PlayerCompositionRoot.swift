import Foundation

// MARK: - PlayerCompositionRoot
/// Composition Root for the Player feature.
/// Creates and wires all dependencies following the Dependency Injection pattern.
final class PlayerCompositionRoot {

    // MARK: - Singleton

    static let shared = PlayerCompositionRoot()

    private init() {
        // Debug log for easier debugging.
        print("🏗️ PlayerCompositionRoot: Initialized.")
    }

    // MARK: - Factory Methods

    /// Creates a PlayerViewModel with all dependencies injected.
    func makePlayerViewModel() -> PlayerViewModel {
        let repository = makeRepository()
        let useCase = GetCurrentlyPlayingTrackUseCase(playerRepository: repository)
        return PlayerViewModel(getCurrentlyPlayingTrackUseCase: useCase)
    }

    /// Creates the repository implementation.
    /// Currently returns a mock-backed repository for development.
    /// TODO: Replace with a real API repository when the backend is ready.
    private func makeRepository() -> PlayerRepositoryProtocol {
        DefaultPlayerRepository(dataSource: MockPlayerDataSource())
    }
}

// MARK: - Convenience Extension

extension PlayerCompositionRoot {

    /// Creates a fully configured PlayerView.
    func makePlayerView() -> PlayerView {
        PlayerView(viewModel: makePlayerViewModel())
    }
}
