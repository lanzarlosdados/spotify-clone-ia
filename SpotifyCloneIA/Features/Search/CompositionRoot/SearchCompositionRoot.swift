import Foundation

// MARK: - SearchCompositionRoot
/// Composition Root for the Search feature.
/// Creates and wires all dependencies following the Dependency Injection pattern.
final class SearchCompositionRoot {

    // MARK: - Shared Instance

    static let shared = SearchCompositionRoot()

    // MARK: - Private Properties

    private let repository: SearchRepositoryProtocol
    private let getFeaturedGenresUseCase: GetFeaturedGenresUseCase
    private let getSearchCategoriesUseCase: GetSearchCategoriesUseCase
    private let searchContentUseCase: SearchContentUseCase

    // MARK: - Initialization

    private init() {
        self.repository = DefaultSearchRepository()
        self.getFeaturedGenresUseCase = GetFeaturedGenresUseCase(repository: repository)
        self.getSearchCategoriesUseCase = GetSearchCategoriesUseCase(repository: repository)
        self.searchContentUseCase = SearchContentUseCase(repository: repository)

        // Debug log for easier debugging.
        print("🏗️ SearchCompositionRoot: Initialized with all dependencies.")
    }

    // MARK: - Factory Methods

    /// Creates a fully configured `SearchViewModel`.
    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(
            getFeaturedGenresUseCase: getFeaturedGenresUseCase,
            getSearchCategoriesUseCase: getSearchCategoriesUseCase,
            searchContentUseCase: searchContentUseCase
        )
    }

    // MARK: - Testing Support

    /// Creates a `SearchViewModel` with a custom repository (e.g. a mock) for testing.
    static func makeSearchViewModel(with repository: SearchRepositoryProtocol) -> SearchViewModel {
        SearchViewModel(
            getFeaturedGenresUseCase: GetFeaturedGenresUseCase(repository: repository),
            getSearchCategoriesUseCase: GetSearchCategoriesUseCase(repository: repository),
            searchContentUseCase: SearchContentUseCase(repository: repository)
        )
    }
}
