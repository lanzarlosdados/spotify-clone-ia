import Foundation

// MARK: - DefaultSearchRepository
/// Implementation of `SearchRepositoryProtocol`.
/// Maps DTOs from the data source into domain entities.
final class DefaultSearchRepository: SearchRepositoryProtocol {

    // MARK: - Properties

    private let dataSource: SearchDataSource

    // MARK: - Initialization

    init(dataSource: SearchDataSource = MockSearchDataSource()) {
        self.dataSource = dataSource
    }

    // MARK: - SearchRepositoryProtocol

    func getSearchCategories() async throws -> [SearchCategory] {
        let dtos = try await dataSource.fetchCategories()

        // Debug log for easier debugging.
        print("✅ DefaultSearchRepository: Fetched \(dtos.count) categories.")
        return dtos.map { $0.toDomain() }
    }

    func getFeaturedGenres() async throws -> [Genre] {
        let dtos = try await dataSource.fetchGenres()

        // Debug log for easier debugging.
        print("✅ DefaultSearchRepository: Fetched \(dtos.count) genres.")
        return dtos.map { $0.toDomain() }
    }

    func search(query: String) async throws -> [SearchResult] {
        let dtos = try await dataSource.search(query: query)
        let results = dtos.compactMap { $0.toDomain() }

        // Debug log for easier debugging.
        print("✅ DefaultSearchRepository: Found \(results.count) results for '\(query)'.")
        return results
    }
}
