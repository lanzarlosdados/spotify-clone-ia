import Foundation

// MARK: - PlaylistDataSource
/// Contract for the Playlist feature's raw data access (DTOs).
protocol PlaylistDataSource {
    func fetchPlaylist(id: String) async throws -> PlaylistDTO
}

// MARK: - MockPlaylistDataSource
/// Loads playlist data from the bundled `PlaylistDetail.json` fixture.
/// The `id` is currently ignored (single fixture); swap for a real
/// `HTTPClient`-backed source when the backend is ready.
final class MockPlaylistDataSource: PlaylistDataSource {

    enum MockError: LocalizedError {
        case fixtureNotFound(String)

        var errorDescription: String? {
            switch self {
            case .fixtureNotFound(let name): return "\(name).json not found in bundle."
            }
        }
    }

    func fetchPlaylist(id: String) async throws -> PlaylistDTO {
        print("🔄 MockPlaylistDataSource: Loading PlaylistDetail.json for id '\(id)'...")

        // Simulate network delay for development.
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5s

        guard let url = Bundle.main.url(forResource: "PlaylistDetail", withExtension: "json") else {
            print("❌ MockPlaylistDataSource: PlaylistDetail.json not found.")
            throw MockError.fixtureNotFound("PlaylistDetail")
        }

        let data = try Data(contentsOf: url)
        let dto = try JSONDecoder().decode(PlaylistDTO.self, from: data)

        print("✅ MockPlaylistDataSource: Loaded '\(dto.title)' with \(dto.tracks.count) tracks.")
        return dto
    }
}
