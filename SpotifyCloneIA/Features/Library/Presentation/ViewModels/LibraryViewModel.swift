import Foundation

// MARK: - LibraryViewModel
/// View model for the Library screen.
/// Manages library items, filtering, and sorting.
/// Annotated with @Observable for reactive SwiftUI views.
@Observable
final class LibraryViewModel {
    
    // MARK: - Properties
    
    /// All library items from the repository.
    var allItems: [LibraryItemModel] = []
    
    /// Currently displayed items (after filtering and sorting).
    var displayedItems: [LibraryItemModel] = []
    
    /// Current sort option selected by the user.
    var currentSortOption: LibrarySortOption = .recents
    
    /// Currently selected filter type (nil = show all).
    var selectedFilter: LibraryItemType?
    
    /// Loading state indicator.
    var isLoading: Bool = false
    
    /// Error message if any operation fails.
    var errorMessage: String?
    
    /// Grid view mode (true) vs List view mode (false).
    var isGridView: Bool = true
    
    // MARK: - Use Cases
    
    private let getLibraryItemsUseCase: GetLibraryItemsUseCase
    private let togglePinUseCase: ToggleLibraryItemPinUseCase
    
    // MARK: - Initialization
    
    init(
        getLibraryItemsUseCase: GetLibraryItemsUseCase,
        togglePinUseCase: ToggleLibraryItemPinUseCase
    ) {
        self.getLibraryItemsUseCase = getLibraryItemsUseCase
        self.togglePinUseCase = togglePinUseCase
        
        // Debug log for easier debugging.
        print("🎯 LibraryViewModel: Initialized with injected use cases.")
    }
    
    // MARK: - Public Methods
    
    /// Loads library items from repository via use case.
    func loadLibraryItems() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Debug log for easier debugging.
        print("🔄 LibraryViewModel: Loading library items...")
        
        do {
            // Execute use case to fetch items
            let items = try await getLibraryItemsUseCase.execute()
            
            await MainActor.run {
                // Map domain entities to presentation models
                allItems = items.map { LibraryItemModel(from: $0) }
                applyFiltersAndSort()
                isLoading = false
            }
            
            // Debug log for easier debugging.
            print("✅ LibraryViewModel: Loaded \(items.count) items.")
        } catch {
            await MainActor.run {
                errorMessage = "Failed to load library: \(error.localizedDescription)"
                isLoading = false
            }
            
            // Debug log for easier debugging.
            print("❌ LibraryViewModel: Error loading items - \(error.localizedDescription)")
        }
    }
    
    /// Changes the current sort option and reapplies sorting.
    /// - Parameter option: New sort option to apply
    func changeSortOption(to option: LibrarySortOption) async {
        // Step 1: Activate loading overlay FIRST
        await MainActor.run {
            isLoading = true
        }
        
        // Debug log for easier debugging.
        print("🔄 LibraryViewModel: Loading overlay activated...")
        
        // Step 2: Wait for loading overlay to fully appear before any data changes
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        // Step 3: Now change sort option and apply filters
        await MainActor.run {
            currentSortOption = option
            applyFiltersAndSort()
        }
        
        // Debug log for easier debugging.
        print("🔄 LibraryViewModel: Sort changed to \(option.rawValue). Rendering...")
        
        // Step 4: Wait for SwiftUI to complete rendering before hiding overlay
        try? await Task.sleep(nanoseconds: 350_000_000) // 0.35 seconds
        
        // Step 5: Hide loading overlay
        await MainActor.run {
            isLoading = false
        }
        
        // Debug log for easier debugging.
        print("✅ LibraryViewModel: Sort applied and rendered successfully.")
    }
    
    /// Toggles filter for a specific item type.
    /// - Parameter type: Item type to filter by (nil to show all)
    func toggleFilter(for type: LibraryItemType?) {
        selectedFilter = type
        applyFiltersAndSort()
        
        // Debug log for easier debugging.
        if let type = type {
            print("🔍 LibraryViewModel: Filter set to \(type.rawValue).")
        } else {
            print("🔍 LibraryViewModel: Filter cleared (showing all).")
        }
    }
    
    /// Toggles between grid and list view modes.
    func toggleViewMode() {
        isGridView.toggle()
        
        // Debug log for easier debugging.
        print("🔄 LibraryViewModel: View mode changed to \(isGridView ? "Grid" : "List").")
    }
    
    /// Toggles the pin status of a library item.
    /// - Parameter itemId: ID of the item to toggle pin status
    func togglePin(for itemId: String) async {
        // Debug log for easier debugging.
        print("📌 LibraryViewModel: Toggling pin for item: \(itemId)...")
        
        do {
            // Execute use case to toggle pin
            let updatedItem = try await togglePinUseCase.execute(for: itemId)
            
            await MainActor.run {
                // Update the item in allItems
                if let index = allItems.firstIndex(where: { $0.id == itemId }) {
                    allItems[index] = LibraryItemModel(from: updatedItem)
                }
                
                // Reapply filters and sorting
                applyFiltersAndSort()
            }
            
            // Debug log for easier debugging.
            print("✅ LibraryViewModel: Pin toggled successfully for item: \(itemId)")
        } catch {
            await MainActor.run {
                errorMessage = "Failed to toggle pin: \(error.localizedDescription)"
            }
            
            // Debug log for easier debugging.
            print("❌ LibraryViewModel: Error toggling pin - \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private Methods
    
    /// Applies current filters and sorting to library items.
    private func applyFiltersAndSort() {
        var items = allItems
        
        // Apply type filter if selected
        if let filter = selectedFilter {
            items = items.filter { $0.type == filter }
        }
        
        // Convert to domain entities for sorting
        let domainItems = items.map { model in
            LibraryItem(
                id: model.id,
                title: model.title,
                description: model.description,
                imageURL: model.imageName,
                type: model.type,
                isPinned: model.isPinned
            )
        }
        
        // Apply sorting
        let sortedDomainItems = currentSortOption.sort(domainItems)
        
        // Convert back to presentation models
        displayedItems = sortedDomainItems.map { LibraryItemModel(from: $0) }
    }
}
