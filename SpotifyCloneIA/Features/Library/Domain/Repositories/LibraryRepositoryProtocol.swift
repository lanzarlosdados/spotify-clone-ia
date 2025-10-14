import Foundation

// MARK: - LibraryRepositoryProtocol
/// Protocol defining the contract for library data access.
/// This is part of the Domain layer and defines what operations are needed,
/// not how they are implemented (implementation is in Data layer).
protocol LibraryRepositoryProtocol {
    
    /// Fetches all library items for the current user.
    /// - Returns: Array of LibraryItem entities
    /// - Throws: Error if fetching fails
    func fetchLibraryItems() async throws -> [LibraryItem]
    
    /// Fetches library items filtered by type.
    /// - Parameter type: Type of items to fetch (Music, Podcast, etc.)
    /// - Returns: Array of LibraryItem entities matching the type
    /// - Throws: Error if fetching fails
    func fetchLibraryItems(ofType type: LibraryItemType) async throws -> [LibraryItem]
    
    /// Toggles the pin status of a library item.
    /// - Parameter itemId: ID of the item to toggle pin status
    /// - Returns: Updated LibraryItem
    /// - Throws: Error if operation fails
    func togglePin(for itemId: String) async throws -> LibraryItem
}
