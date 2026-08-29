import Foundation

// MARK: - PlayerViewModel
/// View model for the Player screen.
/// Annotated with @Observable for reactive SwiftUI views.
@Observable
final class PlayerViewModel {

    // MARK: - Properties

    var track: Track?
    var isLoading = false
    var errorMessage: String?

    // MARK: - Use Cases

    private let getCurrentlyPlayingTrackUseCase: GetCurrentlyPlayingTrackUseCase

    // MARK: - Initialization

    init(getCurrentlyPlayingTrackUseCase: GetCurrentlyPlayingTrackUseCase) {
        self.getCurrentlyPlayingTrackUseCase = getCurrentlyPlayingTrackUseCase

        // Debug log for easier debugging.
        print("🎯 PlayerViewModel: Initialized.")
    }

    // MARK: - Public Methods

    /// Loads the currently playing track.
    func load() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        // Debug log for easier debugging.
        print("🔄 PlayerViewModel: Loading currently playing track...")

        do {
            let track = try await getCurrentlyPlayingTrackUseCase.execute()
            await MainActor.run {
                self.track = track
                isLoading = false
            }

            // Debug log for easier debugging.
            print("✅ PlayerViewModel: Loaded '\(track.title)'.")
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isLoading = false
            }

            // Debug log for easier debugging.
            print("❌ PlayerViewModel: Error loading track - \(error.localizedDescription)")
        }
    }
}
