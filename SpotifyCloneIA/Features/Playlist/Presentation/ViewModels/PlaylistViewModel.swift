import Foundation

// MARK: - PlaylistViewModel
@Observable
final class PlaylistViewModel {

    // MARK: - State

    private(set) var playlist: PlaylistModel?
    private(set) var domainPlaylist: Playlist?
    var isLoading = false
    var errorMessage: String?

    // MARK: - Use Cases

    private let getPlaylistUseCase: GetPlaylistUseCase

    // MARK: - Init

    init(getPlaylistUseCase: GetPlaylistUseCase) {
        self.getPlaylistUseCase = getPlaylistUseCase
        print("🎯 PlaylistViewModel: Initialized.")
    }

    // MARK: - Load

    func load(id: String) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        print("🔄 PlaylistViewModel: Loading playlist '\(id)'...")

        do {
            let playlist = try await getPlaylistUseCase.execute(id: id)
            await MainActor.run {
                self.domainPlaylist = playlist
                self.playlist = PlaylistModel(from: playlist)
                self.isLoading = false
            }
            print("✅ PlaylistViewModel: Loaded '\(playlist.title)'.")
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
            print("❌ PlaylistViewModel: Error loading playlist - \(error.localizedDescription)")
        }
    }

    /// Ordered domain tracks for the playback hand-off.
    var playbackQueue: [Track] {
        domainPlaylist?.tracks ?? []
    }
}
