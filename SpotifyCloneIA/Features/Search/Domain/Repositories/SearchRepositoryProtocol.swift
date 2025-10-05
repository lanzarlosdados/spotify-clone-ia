import Foundation

// MARK: - SearchRepositoryProtocol
/// Protocol defining the interface for search repository operations.
/// This protocol follows Clean Architecture principles, defining what operations are available
/// without specifying how they're implemented.
protocol SearchRepositoryProtocol {
    
    /// Fetches all available search categories.
    /// - Returns: An array of `SearchCategory` entities.
    /// - Throws: An error if the fetch operation fails.
    func getSearchCategories() async throws -> [SearchCategory]
    
    /// Fetches featured musical genres for exploration.
    /// - Returns: An array of `Genre` entities.
    /// - Throws: An error if the fetch operation fails.
    func getFeaturedGenres() async throws -> [Genre]
    
    /// Performs a search query across all content types.
    /// - Parameter query: The search query string.
    /// - Returns: An array of `SearchResult` entities matching the query.
    /// - Throws: An error if the search operation fails.
    func search(query: String) async throws -> [SearchResult]
}
