import Foundation

// MARK: - ToggleLibraryItemPinUseCase
/// Use case for toggling the pin status of a library item.
/// Encapsulates the business logic for pinning/unpinning items.
struct ToggleLibraryItemPinUseCase {
    
    // MARK: - Properties
    
    private let repository: LibraryRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: LibraryRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    
    /// Executes the use case to toggle pin status of an item.
    /// - Parameter itemId: ID of the item to toggle
    /// - Returns: Updated LibraryItem entity
    /// - Throws: Error if repository fails
    func execute(for itemId: String) async throws -> LibraryItem {
        // Debug log for easier debugging.
        print("📌 ToggleLibraryItemPinUseCase: Toggling pin for item: \(itemId)...")
        
        let updatedItem = try await repository.togglePin(for: itemId)
        
        // Debug log for easier debugging.
        print("✅ ToggleLibraryItemPinUseCase: Item \(itemId) pin status updated to: \(updatedItem.isPinned)")
        
        return updatedItem
    }
}
