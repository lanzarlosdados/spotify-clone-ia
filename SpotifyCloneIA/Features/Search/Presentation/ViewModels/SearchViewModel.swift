import Foundation

// MARK: - SearchViewModel
/// View model for the Search screen.
/// Manages the state and business logic for the search feature using async/await.
/// Annotated with @Observable for reactive SwiftUI views.
@Observable
final class SearchViewModel {
    
    // MARK: - Properties
    
    /// Search query text entered by the user.
    var searchQuery: String = ""
    
    /// Featured genres for "Explore your musical type" section.
    var genres: [GenreModel] = []
    
    /// Search categories for "Browse all" section.
    var categories: [SearchCategoryModel] = []
    
    /// Search results when user performs a search.
    var searchResults: [SearchResultModel] = []
    
    /// Loading state for genres.
    var isLoadingGenres: Bool = false
    
    /// Loading state for categories.
    var isLoadingCategories: Bool = false
    
    /// Loading state for search results.
    var isSearching: Bool = false
    
    /// Error message if any operation fails.
    var errorMessage: String?
    
    /// Indicates if search results should be shown (query is not empty).
    var showingSearchResults: Bool {
        !searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Use Cases
    
    private let getFeaturedGenresUseCase: GetFeaturedGenresUseCase
    private let getSearchCategoriesUseCase: GetSearchCategoriesUseCase
    private let searchContentUseCase: SearchContentUseCase
    
    // MARK: - Initialization
    
    init(
        getFeaturedGenresUseCase: GetFeaturedGenresUseCase,
        getSearchCategoriesUseCase: GetSearchCategoriesUseCase,
        searchContentUseCase: SearchContentUseCase
    ) {
        self.getFeaturedGenresUseCase = getFeaturedGenresUseCase
        self.getSearchCategoriesUseCase = getSearchCategoriesUseCase
        self.searchContentUseCase = searchContentUseCase
        
        // Debug log for easier debugging.
        print("🎯 SearchViewModel: Initialized.")
    }
    
    // MARK: - Public Methods
    
    /// Loads initial data for the search screen (genres and categories).
    func loadInitialData() async {
        // Debug log for easier debugging.
        print("🔄 SearchViewModel: Loading initial data...")
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadFeaturedGenres() }
            group.addTask { await self.loadSearchCategories() }
            await group.waitForAll()
        }
        
        // Debug log for easier debugging.
        print("✅ SearchViewModel: Initial data loaded.")
    }
    
    /// Loads featured genres for the "Explore your musical type" section.
    func loadFeaturedGenres() async {
        await MainActor.run {
            isLoadingGenres = true
            errorMessage = nil
        }
        
        // Debug log for easier debugging.
        print("🔄 SearchViewModel: Loading featured genres...")
        
        do {
            let genreEntities = try await getFeaturedGenresUseCase.execute()
            let mapped = genreEntities.map { GenreModel(from: $0) }
            
            await MainActor.run {
                genres = mapped
                isLoadingGenres = false
            }
            
            // Debug log for easier debugging.
            print("✅ SearchViewModel: Loaded \(mapped.count) genres.")
        } catch {
            await MainActor.run {
                errorMessage = "Failed to load genres: \(error.localizedDescription)"
                isLoadingGenres = false
            }
            
            // Debug log for easier debugging.
            print("❌ SearchViewModel: Error loading genres - \(error.localizedDescription)")
        }
    }
    
    /// Loads search categories for the "Browse all" section.
    func loadSearchCategories() async {
        await MainActor.run {
            isLoadingCategories = true
            errorMessage = nil
        }
        
        // Debug log for easier debugging.
        print("🔄 SearchViewModel: Loading search categories...")
        
        do {
            let categoryEntities = try await getSearchCategoriesUseCase.execute()
            let mapped = categoryEntities.map { SearchCategoryModel(from: $0) }
            
            await MainActor.run {
                categories = mapped
                isLoadingCategories = false
            }
            
            // Debug log for easier debugging.
            print("✅ SearchViewModel: Loaded \(mapped.count) categories.")
        } catch {
            await MainActor.run {
                errorMessage = "Failed to load categories: \(error.localizedDescription)"
                isLoadingCategories = false
            }
            
            // Debug log for easier debugging.
            print("❌ SearchViewModel: Error loading categories - \(error.localizedDescription)")
        }
    }
    
    /// Performs a search with the current query.
    func performSearch() async {
        let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            await MainActor.run {
                searchResults = []
            }
            return
        }
        
        await MainActor.run {
            isSearching = true
            errorMessage = nil
        }
        
        // Debug log for easier debugging.
        print("🔍 SearchViewModel: Performing search for '\(trimmed)'...")
        
        do {
            let resultEntities = try await searchContentUseCase.execute(query: trimmed)
            let mapped = resultEntities.map { SearchResultModel(from: $0) }
            
            await MainActor.run {
                searchResults = mapped
                isSearching = false
            }
            
            // Debug log for easier debugging.
            print("✅ SearchViewModel: Found \(mapped.count) results.")
        } catch {
            await MainActor.run {
                errorMessage = "Search failed: \(error.localizedDescription)"
                searchResults = []
                isSearching = false
            }
            
            // Debug log for easier debugging.
            print("❌ SearchViewModel: Search error - \(error.localizedDescription)")
        }
    }
    
    /// Clears the search query and results.
    func clearSearch() {
        searchQuery = ""
        searchResults = []
        
        // Debug log for easier debugging.
        print("🗑️ SearchViewModel: Search cleared.")
    }
}
