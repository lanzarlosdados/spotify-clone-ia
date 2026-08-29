import Foundation

// MARK: - SearchDataSource
/// Contract for the Search feature's raw data access (DTOs).
protocol SearchDataSource {
    func fetchCategories() async throws -> [SearchCategoryDTO]
    func fetchGenres() async throws -> [GenreDTO]
    func search(query: String) async throws -> [SearchResultDTO]
}

// MARK: - MockSearchDataSource
/// Loads Search data from bundled JSON fixtures in `Data/Mock/`.
/// TODO: replace with a real data source (HTTPClient) when the backend is ready.
final class MockSearchDataSource: SearchDataSource {

    enum MockError: LocalizedError {
        case fixtureNotFound(String)

        var errorDescription: String? {
            switch self {
            case .fixtureNotFound(let name): return "\(name).json not found in bundle."
            }
        }
    }

    func fetchCategories() async throws -> [SearchCategoryDTO] {
        try await load("SearchCategories", delay: 0.5)
    }

    func fetchGenres() async throws -> [GenreDTO] {
        try await load("SearchGenres", delay: 0.5)
    }

    func search(query: String) async throws -> [SearchResultDTO] {
        // Debug log for easier debugging.
        print("🔄 MockSearchDataSource: Searching for '\(query)'...")
        return try await load("SearchResults", delay: 0.8)
    }

    // MARK: - Helpers

    private func load<T: Decodable>(_ name: String, delay seconds: Double) async throws -> T {
        // Simulate network delay for development.
        try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))

        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            print("❌ MockSearchDataSource: \(name).json not found.")
            throw MockError.fixtureNotFound(name)
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
