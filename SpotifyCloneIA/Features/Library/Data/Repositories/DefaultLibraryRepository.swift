import Foundation

// MARK: - MockLibraryRepository
/// Mock implementation of LibraryRepositoryProtocol for development and testing.
/// Returns hardcoded mock data to simulate API responses.
/// TODO: Replace with real API repository when backend is ready.
final class MockLibraryRepository: LibraryRepositoryProtocol {
    
    // MARK: - Properties
    
    /// In-memory storage of library items (simulates database/cache).
    private var items: [LibraryItem]
    
    // MARK: - Initialization
    
    init() {
        // Initialize with mock data (uses images from Assets.xcassets/mock_resources/images)
        self.items = Self.createMockData()
        
        // Debug log for easier debugging.
        print("🎯 MockLibraryRepository: Initialized with \(items.count) mock items (with real images from Assets).")
    }
    
    // MARK: - LibraryRepositoryProtocol Implementation
    
    func fetchLibraryItems() async throws -> [LibraryItem] {
        // Debug log for easier debugging.
        print("🔄 MockLibraryRepository: Fetching all library items...")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Debug log for easier debugging.
        print("✅ MockLibraryRepository: Returning \(items.count) items.")
        
        return items
    }
    
    func fetchLibraryItems(ofType type: LibraryItemType) async throws -> [LibraryItem] {
        // Debug log for easier debugging.
        print("🔄 MockLibraryRepository: Fetching items of type \(type.rawValue)...")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        let filtered = items.filter { $0.type == type }
        
        // Debug log for easier debugging.
        print("✅ MockLibraryRepository: Returning \(filtered.count) items of type \(type.rawValue).")
        
        return filtered
    }
    
    func togglePin(for itemId: String) async throws -> LibraryItem {
        // Debug log for easier debugging.
        print("📌 MockLibraryRepository: Toggling pin for item: \(itemId)...")
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        // Find the item and toggle its pin status
        guard let index = items.firstIndex(where: { $0.id == itemId }) else {
            // Debug log for easier debugging.
            print("❌ MockLibraryRepository: Item not found: \(itemId)")
            throw MockRepositoryError.itemNotFound
        }
        
        let currentItem = items[index]
        let updatedItem = LibraryItem(
            id: currentItem.id,
            title: currentItem.title,
            description: currentItem.description,
            imageURL: currentItem.imageURL,
            type: currentItem.type,
            isPinned: !currentItem.isPinned,  // Toggle pin status
            dateAdded: currentItem.dateAdded
        )
        
        items[index] = updatedItem
        
        // Debug log for easier debugging.
        print("✅ MockLibraryRepository: Item \(itemId) pin toggled to: \(updatedItem.isPinned)")
        
        return updatedItem
    }
    
    // MARK: - Mock Data Creation
    
    /// Creates mock library items for development.
    /// Uses images from Assets.xcassets/mock_resources/images
    private static func createMockData() -> [LibraryItem] {
        return [
            LibraryItem(
                id: "1",
                title: "Liked Songs",
                description: "Playlist • 16 songs",
                imageURL: "rock-mix",
                type: .likedSongs,
                isPinned: true,
                dateAdded: Date().addingTimeInterval(-86400 * 5) // 5 days ago
            ),
            LibraryItem(
                id: "2",
                title: "Solved Murders",
                description: "Podcast • 24 episodes",
                imageURL: "solved-murders-podcast",
                type: .podcast,
                isPinned: true,
                dateAdded: Date().addingTimeInterval(-86400 * 3) // 3 days ago
            ),
            LibraryItem(
                id: "3",
                title: "Arctic Monkeys",
                description: "Artist",
                imageURL: "arctic-monkeys",
                type: .artist,
                isPinned: false,
                dateAdded: Date().addingTimeInterval(-86400 * 10) // 10 days ago
            ),
            LibraryItem(
                id: "4",
                title: "Rock Mix",
                description: "Playlist • 42 songs",
                imageURL: "rock-mix",
                type: .playlist,
                isPinned: false,
                dateAdded: Date().addingTimeInterval(-86400 * 2) // 2 days ago
            ),
            LibraryItem(
                id: "5",
                title: "Blur Special Edition",
                description: "Album • Blur",
                imageURL: "blur-special-edition",
                type: .album,
                isPinned: false,
                dateAdded: Date().addingTimeInterval(-86400 * 7) // 7 days ago
            ),
            LibraryItem(
                id: "6",
                title: "Pop Mix",
                description: "Playlist • 28 songs",
                imageURL: "pop-mix",
                type: .playlist,
                isPinned: false,
                dateAdded: Date().addingTimeInterval(-86400 * 1) // 1 day ago
            ),
            LibraryItem(
                id: "7",
                title: "Daily Episodes",
                description: "Podcast • 8 new episodes",
                imageURL: "episode-one",
                type: .podcast,
                isPinned: false,
                dateAdded: Date().addingTimeInterval(-86400 * 15) // 15 days ago
            ),
            LibraryItem(
                id: "8",
                title: "Beastie Boys",
                description: "Artist",
                imageURL: "beastie-boys",
                type: .artist,
                isPinned: false,
                dateAdded: Date().addingTimeInterval(-86400 * 20) // 20 days ago
            ),
            LibraryItem(
                id: "9",
                title: "Upbeat Mix",
                description: "Playlist • 55 songs",
                imageURL: "upbeat-mix",
                type: .playlist,
                isPinned: false,
                dateAdded: Date().addingTimeInterval(-86400 * 4) // 4 days ago
            ),
            LibraryItem(
                id: "10",
                title: "The Cure",
                description: "Artist",
                imageURL: "the-cure",
                type: .artist,
                isPinned: false,
                dateAdded: Date().addingTimeInterval(-86400 * 12) // 12 days ago
            ),
            LibraryItem(
                id: "11",
                title: "Blur",
                description: "Album • Blur",
                imageURL: "blur",
                type: .album,
                isPinned: false,
                dateAdded: Date().addingTimeInterval(-86400 * 8) // 8 days ago
            ),
            LibraryItem(
                id: "12",
                title: "Today's Hits",
                description: "Playlist • 62 songs",
                imageURL: "today-one",
                type: .playlist,
                isPinned: false,
                dateAdded: Date().addingTimeInterval(-86400 * 6) // 6 days ago
            )
        ]
    }
}

// MARK: - MockRepositoryError

/// Errors that can occur in the mock repository.
enum MockRepositoryError: LocalizedError {
    case itemNotFound
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .itemNotFound:
            return "Library item not found"
        case .networkError:
            return "Network error occurred"
        }
    }
}
