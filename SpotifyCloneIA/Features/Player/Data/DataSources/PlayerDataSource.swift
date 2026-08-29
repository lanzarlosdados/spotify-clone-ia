import Foundation

// MARK: - PlayerDataSource

protocol PlayerDataSource {
    func getCurrentlyPlayingTrack() async throws -> TrackDTO
}

// MARK: - MockPlayerDataSource
/// Loads the currently playing track from the bundled `MockTrack.json` fixture.
/// TODO: replace with a real data source (HTTPClient) when the backend is ready.
final class MockPlayerDataSource: PlayerDataSource {

    enum MockError: LocalizedError {
        case fixtureNotFound

        var errorDescription: String? {
            switch self {
            case .fixtureNotFound: return "MockTrack.json not found."
            }
        }
    }

    func getCurrentlyPlayingTrack() async throws -> TrackDTO {
        // Debug log for easier debugging.
        print("🔄 MockPlayerDataSource: Loading MockTrack.json...")

        // Simulate network delay for development.
        try await Task.sleep(nanoseconds: 400_000_000) // 0.4s

        guard let url = Bundle.main.url(forResource: "MockTrack", withExtension: "json") else {
            print("❌ MockPlayerDataSource: MockTrack.json not found.")
            throw MockError.fixtureNotFound
        }

        let data = try Data(contentsOf: url)
        let dto = try JSONDecoder().decode(TrackDTO.self, from: data)

        // Debug log for easier debugging.
        print("✅ MockPlayerDataSource: Loaded track '\(dto.title)'.")
        return dto
    }
}
