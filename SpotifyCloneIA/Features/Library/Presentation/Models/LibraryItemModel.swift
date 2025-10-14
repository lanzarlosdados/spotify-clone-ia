import Foundation

// MARK: - LibraryItemModel
/// Presentation model for library items.
/// Maps from LibraryItem domain entity to view-friendly format.
struct LibraryItemModel: Identifiable {
    
    // MARK: - Properties
    
    let id: String
    let title: String
    let description: String
    let imageName: String  // Local asset name or URL
    let type: LibraryItemType
    let isPinned: Bool
    let showPin: Bool
    
    // MARK: - Initialization from Domain Entity
    
    /// Maps LibraryItem domain entity to presentation model.
    /// - Parameter libraryItem: Domain entity from use case
    init(from libraryItem: LibraryItem) {
        self.id = libraryItem.id
        self.title = libraryItem.title
        self.description = libraryItem.description
        
        // Use imageURL if available, otherwise fallback to placeholder
        if let imageURL = libraryItem.imageURL, !imageURL.isEmpty {
            self.imageName = imageURL
        } else {
            // Use placeholder based on type
            self.imageName = Self.placeholderImage(for: libraryItem.type)
        }
        
        self.type = libraryItem.type
        self.isPinned = libraryItem.isPinned
        self.showPin = libraryItem.isPinned
    }
    
    // MARK: - Helper Methods
    
    /// Returns placeholder image name for a given library item type.
    /// Images should exist in Assets.xcassets
    private static func placeholderImage(for type: LibraryItemType) -> String {
        switch type {
        case .music, .likedSongs:
            return "playlist-placeholder"
        case .podcast:
            return "podcast-placeholder"
        case .artist:
            return "artist-placeholder"
        case .album:
            return "album-placeholder"
        case .playlist:
            return "playlist-placeholder"
        }
    }
}
