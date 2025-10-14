import Foundation

// MARK: - LibraryItem
/// Entity representing an item in the user's library.
/// Can be a playlist, album, podcast, artist, etc.
struct LibraryItem: Identifiable, Equatable {
    
    // MARK: - Properties
    
    let id: String
    let title: String
    let description: String
    let imageURL: String?
    let type: LibraryItemType
    let isPinned: Bool
    let dateAdded: Date
    
    // MARK: - Initialization
    
    init(
        id: String,
        title: String,
        description: String,
        imageURL: String? = nil,
        type: LibraryItemType,
        isPinned: Bool = false,
        dateAdded: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.type = type
        self.isPinned = isPinned
        self.dateAdded = dateAdded
    }
}
