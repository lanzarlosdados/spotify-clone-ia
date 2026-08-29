import Foundation

// MARK: - DefaultPlaylistRepository
final class DefaultPlaylistRepository: PlaylistRepositoryProtocol {

    private let dataSource: PlaylistDataSource

    init(dataSource: PlaylistDataSource = MockPlaylistDataSource()) {
        self.dataSource = dataSource
    }

    func getPlaylist(id: String) async throws -> Playlist {
        let dto = try await dataSource.fetchPlaylist(id: id)
        return dto.toDomain()
    }
}
