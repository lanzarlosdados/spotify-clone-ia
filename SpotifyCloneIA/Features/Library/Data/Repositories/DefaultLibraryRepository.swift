import Foundation

// MARK: - DefaultLibraryRepository
/// Implementation of `LibraryRepositoryProtocol`.
/// Maps DTOs from the data source into domain entities and keeps an in-memory
/// copy so `togglePin` can mutate state between calls (simulates a backend/cache).
final class DefaultLibraryRepository: LibraryRepositoryProtocol {

    // MARK: - Properties

    private let dataSource: LibraryDataSource
    private var cache: [LibraryItem]?

    // MARK: - Initialization

    init(dataSource: LibraryDataSource = MockLibraryDataSource()) {
        self.dataSource = dataSource
    }

    // MARK: - LibraryRepositoryProtocol

    func fetchLibraryItems() async throws -> [LibraryItem] {
        try await loadedItems()
    }

    func fetchLibraryItems(ofType type: LibraryItemType) async throws -> [LibraryItem] {
        try await loadedItems().filter { $0.type == type }
    }

    func togglePin(for itemId: String) async throws -> LibraryItem {
        var items = try await loadedItems()

        guard let index = items.firstIndex(where: { $0.id == itemId }) else {
            print("❌ DefaultLibraryRepository: Item not found: \(itemId)")
            throw LibraryRepositoryError.itemNotFound
        }

        // Simulate network delay for development.
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2s

        let current = items[index]
        let updated = LibraryItem(
            id: current.id,
            title: current.title,
            description: current.description,
            imageURL: current.imageURL,
            type: current.type,
            isPinned: !current.isPinned,
            dateAdded: current.dateAdded
        )
        items[index] = updated
        cache = items

        // Debug log for easier debugging.
        print("✅ DefaultLibraryRepository: Item \(itemId) pin -> \(updated.isPinned)")
        return updated
    }

    // MARK: - Helpers

    private func loadedItems() async throws -> [LibraryItem] {
        if let cache { return cache }
        let dtos = try await dataSource.fetchLibraryItems()
        let items = dtos.compactMap { $0.toDomain() }
        cache = items
        return items
    }
}

// MARK: - LibraryRepositoryError

enum LibraryRepositoryError: LocalizedError {
    case itemNotFound

    var errorDescription: String? {
        switch self {
        case .itemNotFound: return "Library item not found"
        }
    }
}
