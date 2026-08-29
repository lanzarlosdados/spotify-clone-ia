import Foundation

// MARK: - GetPlaylistUseCase
final class GetPlaylistUseCase {

    private let repository: PlaylistRepositoryProtocol

    init(repository: PlaylistRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: String) async throws -> Playlist {
        try await repository.getPlaylist(id: id)
    }
}
