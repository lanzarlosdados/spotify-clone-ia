import SwiftUI

// MARK: - PlaylistView
/// Playlist detail: centered header + track list. Pushed onto a `NavigationStack`
/// via `PlaylistRoute`.
struct PlaylistView: View {

    let playlistID: String

    // Using `let` for the @Observable view model as per state management rules.
    let viewModel: PlaylistViewModel

    @State private var showPlayer = false

    init(playlistID: String, viewModel: PlaylistViewModel? = nil) {
        self.playlistID = playlistID
        self.viewModel = viewModel ?? PlaylistCompositionRoot.shared.makePlaylistViewModel(id: playlistID)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.cardBackground, Color.primaryBackground],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if let playlist = viewModel.playlist {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        PlaylistHeaderView(playlist: playlist) { startPlayback(from: nil) }

                        ForEach(playlist.tracks) { track in
                            TrackRowView(track: track)
                                .contentShape(Rectangle())
                                .onTapGesture { startPlayback(from: track.id) }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            } else if let error = viewModel.errorMessage {
                errorView(error)
            } else {
                ProgressView().tint(.spotifyGreen)
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.playlist?.title ?? "")
                    .font(.circular(.bold, size: 16))
                    .foregroundColor(.textPrimary)
            }
        }
        .task { await viewModel.load(id: playlistID) }
        .fullScreenCover(isPresented: $showPlayer) {
            PlayerCompositionRoot.shared.makePlayerView()
        }
    }

    // MARK: - Playback hand-off

    private func startPlayback(from trackID: String?) {
        let queue = viewModel.playbackQueue
        guard !queue.isEmpty else { return }

        let startIndex = trackID
            .flatMap { id in queue.firstIndex(where: { $0.id == id }) } ?? 0

        PlayerCompositionRoot.shared.playbackController.load(
            queue: queue,
            startAt: startIndex,
            context: "PLAYING FROM PLAYLIST",
            contextTitle: viewModel.playlist?.title ?? ""
        )
        showPlayer = true
    }

    // MARK: - Error

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.textSecondary)
            Text(message)
                .font(.circular(.book, size: 14))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
    }
}

#Preview {
    NavigationStack {
        PlaylistView(playlistID: "imagine-dragons-mix")
            .preferredColorScheme(.dark)
    }
}
