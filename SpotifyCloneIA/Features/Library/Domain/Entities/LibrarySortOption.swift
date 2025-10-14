import Foundation

// MARK: - LibrarySortOption
/// Enum representing sorting options for library items.
/// Based on Figma design showing "Recents" as default option.
enum LibrarySortOption: String, CaseIterable {
    case recents = "Recents"
    case recentlyAdded = "Recently Added"
    case alphabetical = "Alphabetical"
    case creator = "Creator"
    
    // MARK: - Sort Logic
    
    /// Sorts an array of LibraryItem according to this option
    func sort(_ items: [LibraryItem]) -> [LibraryItem] {
        switch self {
        case .recents, .recentlyAdded:
            // Sort by date added (newest first)
            return items.sorted { $0.dateAdded > $1.dateAdded }
        case .alphabetical:
            // Sort alphabetically by title
            return items.sorted { $0.title < $1.title }
        case .creator:
            // Sort by description (usually contains creator name)
            return items.sorted { $0.description < $1.description }
        }
    }
}
