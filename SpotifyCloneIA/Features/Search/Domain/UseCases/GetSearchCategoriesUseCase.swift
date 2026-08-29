import Foundation

// MARK: - GetSearchCategoriesUseCase
/// Use case for fetching search categories.
/// This encapsulates the business logic for retrieving the "Browse all" categories.
final class GetSearchCategoriesUseCase {
    
    // MARK: - Properties
    
    private let repository: SearchRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    
    /// Executes the use case to fetch search categories.
    /// - Returns: An array of `SearchCategory` entities.
    /// - Throws: An error if the operation fails.
    func execute() async throws -> [SearchCategory] {
        // Debug log for easier debugging.
        print("🔍 GetSearchCategoriesUseCase: Fetching search categories...")
        
        let categories = try await repository.getSearchCategories()
        
        // Debug log for easier debugging.
        print("✅ GetSearchCategoriesUseCase: Fetched \(categories.count) categories.")
        
        return categories
    }
}
