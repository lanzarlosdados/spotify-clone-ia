import Foundation

// MARK: - PlaylistRepositoryProtocol
protocol PlaylistRepositoryProtocol {
    func getPlaylist(id: String) async throws -> Playlist
}
