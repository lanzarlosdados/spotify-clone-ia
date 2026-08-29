import Foundation

// MARK: - HomeDataSource
/// Contract for the Home feature's raw data access.
protocol HomeDataSource {
    func fetchHomeFeed() async throws -> HomeFeedDTO
}

// MARK: - MockHomeDataSource
/// Loads the Home feed from the bundled `HomeFeed.json` fixture.
/// TODO: replace with a real data source (HTTPClient) when the backend is ready.
final class MockHomeDataSource: HomeDataSource {

    enum MockError: LocalizedError {
        case fixtureNotFound

        var errorDescription: String? {
            switch self {
            case .fixtureNotFound: return "HomeFeed.json not found in bundle."
            }
        }
    }

    func fetchHomeFeed() async throws -> HomeFeedDTO {
        // Debug log for easier debugging.
        print("🔄 MockHomeDataSource: Loading HomeFeed.json...")

        // Simulate network delay for development.
        try await Task.sleep(nanoseconds: 400_000_000) // 0.4s

        guard let url = Bundle.main.url(forResource: "HomeFeed", withExtension: "json") else {
            print("❌ MockHomeDataSource: HomeFeed.json not found.")
            throw MockError.fixtureNotFound
        }

        let data = try Data(contentsOf: url)
        let dto = try JSONDecoder().decode(HomeFeedDTO.self, from: data)

        // Debug log for easier debugging.
        print("✅ MockHomeDataSource: Home feed loaded.")
        return dto
    }
}
