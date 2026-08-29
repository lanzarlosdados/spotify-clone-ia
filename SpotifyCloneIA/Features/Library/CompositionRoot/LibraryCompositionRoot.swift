import Foundation

// MARK: - LibraryCompositionRoot
/// Composition Root for the Library feature.
/// This class is responsible for creating and wiring all dependencies
/// following the Dependency Injection pattern.
/// Keeps dependencies centralized and makes it easy to swap implementations.
final class LibraryCompositionRoot {
    
    // MARK: - Singleton
    
    static let shared = LibraryCompositionRoot()
    
    // MARK: - Private Initialization
    
    private init() {
        // Debug log for easier debugging.
        print("🏗️ LibraryCompositionRoot: Initialized.")
    }
    
    // MARK: - Factory Methods
    
    /// Creates a LibraryViewModel with all dependencies injected.
    /// - Returns: Fully configured LibraryViewModel
    func makeLibraryViewModel() -> LibraryViewModel {
        // Create repository (using mock for now)
        let repository = makeRepository()
        
        // Create use cases with repository
        let getLibraryItemsUseCase = GetLibraryItemsUseCase(repository: repository)
        let togglePinUseCase = ToggleLibraryItemPinUseCase(repository: repository)
        
        // Create and return view model with use cases
        return LibraryViewModel(
            getLibraryItemsUseCase: getLibraryItemsUseCase,
            togglePinUseCase: togglePinUseCase
        )
    }
    
    /// Creates the repository implementation.
    /// Currently returns a mock-backed repository for development.
    /// TODO: Replace the data source with a real (HTTPClient) one when the backend is ready.
    /// - Returns: LibraryRepositoryProtocol implementation
    private func makeRepository() -> LibraryRepositoryProtocol {
        return DefaultLibraryRepository(dataSource: MockLibraryDataSource())
    }
}

// MARK: - Convenience Extension

extension LibraryCompositionRoot {
    
    /// Creates a complete LibraryView with all dependencies configured.
    /// This is the main entry point for creating the Library screen.
    /// - Returns: Fully configured LibraryView
    func makeLibraryView() -> LibraryView {
        let viewModel = makeLibraryViewModel()
        return LibraryView(viewModel: viewModel)
    }
}
