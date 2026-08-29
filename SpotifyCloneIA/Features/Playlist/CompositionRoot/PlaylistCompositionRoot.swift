import Foundation

// MARK: - PlaylistCompositionRoot
/// Composition Root for the Playlist feature.
final class PlaylistCompositionRoot {

    // MARK: - Singleton

    static let shared = PlaylistCompositionRoot()

    private init() {
        print("🏗️ PlaylistCompositionRoot: Initialized.")
    }

    // MARK: - Factory Methods

    func makePlaylistViewModel(id: String) -> PlaylistViewModel {
        PlaylistViewModel(getPlaylistUseCase: GetPlaylistUseCase(repository: makeRepository()))
    }

    private func makeRepository() -> PlaylistRepositoryProtocol {
        DefaultPlaylistRepository(dataSource: MockPlaylistDataSource())
    }

    // MARK: - Testing Support

    /// Creates a `PlaylistViewModel` with a custom repository (e.g. a mock) for testing.
    static func makePlaylistViewModel(with repository: PlaylistRepositoryProtocol, id: String) -> PlaylistViewModel {
        PlaylistViewModel(getPlaylistUseCase: GetPlaylistUseCase(repository: repository))
    }
}

// MARK: - Convenience Extension

extension PlaylistCompositionRoot {

    /// Creates a fully configured `PlaylistView`.
    func makePlaylistView(playlistID: String) -> PlaylistView {
        PlaylistView(playlistID: playlistID, viewModel: makePlaylistViewModel(id: playlistID))
    }
}
