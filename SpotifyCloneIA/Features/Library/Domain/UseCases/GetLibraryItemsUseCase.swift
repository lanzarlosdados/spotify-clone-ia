import Foundation

// MARK: - GetLibraryItemsUseCase
/// Use case for fetching library items.
/// Encapsulates the business logic for retrieving user's library collection.
struct GetLibraryItemsUseCase {
    
    // MARK: - Properties
    
    private let repository: LibraryRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: LibraryRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    
    /// Executes the use case to fetch all library items.
    /// - Returns: Array of LibraryItem entities
    /// - Throws: Error if repository fails
    func execute() async throws -> [LibraryItem] {
        // Debug log for easier debugging.
        print("🔍 GetLibraryItemsUseCase: Executing use case...")
        
        let items = try await repository.fetchLibraryItems()
        
        // Debug log for easier debugging.
        print("✅ GetLibraryItemsUseCase: Retrieved \(items.count) items from repository.")
        
        return items
    }
    
    /// Executes the use case to fetch library items of a specific type.
    /// - Parameter type: Type of items to fetch
    /// - Returns: Array of LibraryItem entities matching the type
    /// - Throws: Error if repository fails
    func execute(ofType type: LibraryItemType) async throws -> [LibraryItem] {
        // Debug log for easier debugging.
        print("🔍 GetLibraryItemsUseCase: Fetching items of type \(type.rawValue)...")
        
        let items = try await repository.fetchLibraryItems(ofType: type)
        
        // Debug log for easier debugging.
        print("✅ GetLibraryItemsUseCase: Retrieved \(items.count) items of type \(type.rawValue).")
        
        return items
    }
}
