import Foundation

// MARK: - HomeViewModel
/// View model for the Home screen.
/// Loads the full `HomeFeed` and exposes it to the view.
/// Annotated with @Observable for reactive SwiftUI views.
@Observable
final class HomeViewModel {

    // MARK: - Properties

    var feed: HomeFeed?
    var isLoading = false
    var errorMessage: String?

    // MARK: - Use Cases

    private let getHomeFeedUseCase: GetHomeFeedUseCase

    // MARK: - Initialization

    init(getHomeFeedUseCase: GetHomeFeedUseCase) {
        self.getHomeFeedUseCase = getHomeFeedUseCase

        // Debug log for easier debugging.
        print("🎯 HomeViewModel: Initialized.")
    }

    // MARK: - Public Methods

    /// Loads the Home feed.
    func load() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        // Debug log for easier debugging.
        print("🔄 HomeViewModel: Loading home feed...")

        do {
            let feed = try await getHomeFeedUseCase.execute()
            await MainActor.run {
                self.feed = feed
                isLoading = false
            }
            print("✅ HomeViewModel: Home feed loaded.")
        } catch {
            await MainActor.run {
                errorMessage = "Failed to load home: \(error.localizedDescription)"
                isLoading = false
            }
            print("❌ HomeViewModel: Error loading home feed - \(error.localizedDescription)")
        }
    }
}
