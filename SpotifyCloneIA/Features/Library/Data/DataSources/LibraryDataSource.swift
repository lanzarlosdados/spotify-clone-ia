import Foundation

// MARK: - LibraryDataSource
/// Contract for the Library feature's raw data access (DTOs).
protocol LibraryDataSource {
    func fetchLibraryItems() async throws -> [LibraryItemDTO]
}

// MARK: - MockLibraryDataSource
/// Loads library items from the bundled `LibraryItems.json` fixture.
/// TODO: replace with a real data source (HTTPClient) when the backend is ready.
final class MockLibraryDataSource: LibraryDataSource {

    enum MockError: LocalizedError {
        case fixtureNotFound

        var errorDescription: String? {
            switch self {
            case .fixtureNotFound: return "LibraryItems.json not found in bundle."
            }
        }
    }

    func fetchLibraryItems() async throws -> [LibraryItemDTO] {
        // Debug log for easier debugging.
        print("🔄 MockLibraryDataSource: Loading LibraryItems.json...")

        // Simulate network delay for development.
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5s

        guard let url = Bundle.main.url(forResource: "LibraryItems", withExtension: "json") else {
            print("❌ MockLibraryDataSource: LibraryItems.json not found.")
            throw MockError.fixtureNotFound
        }

        let data = try Data(contentsOf: url)
        let dtos = try JSONDecoder().decode([LibraryItemDTO].self, from: data)

        // Debug log for easier debugging.
        print("✅ MockLibraryDataSource: Loaded \(dtos.count) items.")
        return dtos
    }
}
