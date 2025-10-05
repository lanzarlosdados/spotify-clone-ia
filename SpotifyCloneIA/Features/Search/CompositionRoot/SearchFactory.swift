import Foundation

// MARK: - SearchFactory
/// Factory responsible for creating and composing all Search feature dependencies.
/// This centralizes dependency injection following Clean Architecture principles.
final class SearchFactory {
    
    // MARK: - Shared Instance
    
    /// Shared singleton instance for the entire app.
    /// This ensures we reuse the same repository and use cases across the feature.
    static let shared = SearchFactory()
    
    // MARK: - Private Properties
    
    private let repository: SearchRepositoryProtocol
    private let getFeaturedGenresUseCase: GetFeaturedGenresUseCase
    private let getSearchCategoriesUseCase: GetSearchCategoriesUseCase
    private let searchContentUseCase: SearchContentUseCase
    
    // MARK: - Initialization
    
    private init() {
        // Create repository
        self.repository = SearchRepository()
        
        // Create use cases with repository
        self.getFeaturedGenresUseCase = GetFeaturedGenresUseCase(repository: repository)
        self.getSearchCategoriesUseCase = GetSearchCategoriesUseCase(repository: repository)
        self.searchContentUseCase = SearchContentUseCase(repository: repository)
        
        // Debug log for easier debugging.
        print("🏭 SearchFactory: Initialized with all dependencies.")
    }
    
    // MARK: - Public Factory Methods
    
    /// Creates a fully configured SearchViewModel with all dependencies.
    /// - Returns: A new instance of `SearchViewModel`.
    func makeSearchViewModel() -> SearchViewModel {
        // Debug log for easier debugging.
        print("🏭 SearchFactory: Creating SearchViewModel...")
        
        return SearchViewModel(
            getFeaturedGenresUseCase: getFeaturedGenresUseCase,
            getSearchCategoriesUseCase: getSearchCategoriesUseCase,
            searchContentUseCase: searchContentUseCase
        )
    }
    
    // MARK: - Testing Support
    
    /// Creates a SearchViewModel with custom dependencies for testing.
    /// - Parameters:
    ///   - repository: Custom repository implementation (e.g., mock)
    /// - Returns: A new instance of `SearchViewModel` with custom dependencies.
    static func makeSearchViewModel(with repository: SearchRepositoryProtocol) -> SearchViewModel {
        let getFeaturedGenresUseCase = GetFeaturedGenresUseCase(repository: repository)
        let getSearchCategoriesUseCase = GetSearchCategoriesUseCase(repository: repository)
        let searchContentUseCase = SearchContentUseCase(repository: repository)
        
        return SearchViewModel(
            getFeaturedGenresUseCase: getFeaturedGenresUseCase,
            getSearchCategoriesUseCase: getSearchCategoriesUseCase,
            searchContentUseCase: searchContentUseCase
        )
    }
}
