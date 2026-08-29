import Foundation

// MARK: - SearchContentUseCase
/// Use case for performing content search operations.
/// This encapsulates the business logic for searching across tracks, albums, artists, and playlists.
final class SearchContentUseCase {
    
    // MARK: - Properties
    
    private let repository: SearchRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    
    /// Executes the use case to search for content.
    /// - Parameter query: The search query string.
    /// - Returns: An array of `SearchResult` entities matching the query.
    /// - Throws: An error if the operation fails.
    func execute(query: String) async throws -> [SearchResult] {
        // Validate query is not empty
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            // Debug log for easier debugging.
            print("⚠️ SearchContentUseCase: Empty query provided.")
            return []
        }
        
        // Debug log for easier debugging.
        print("🔍 SearchContentUseCase: Searching for '\(query)'...")
        
        let results = try await repository.search(query: query)
        
        // Debug log for easier debugging.
        print("✅ SearchContentUseCase: Found \(results.count) results for '\(query)'.")
        
        return results
    }
}
