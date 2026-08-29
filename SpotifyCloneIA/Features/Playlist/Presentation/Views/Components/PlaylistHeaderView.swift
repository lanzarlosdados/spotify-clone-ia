import SwiftUI

// MARK: - PlaylistHeaderView
/// Centered artwork, description, owner, meta line, and the action row
/// (like · more · floating green play button).
struct PlaylistHeaderView: View {

    let playlist: PlaylistModel
    var onPlay: () -> Void = {}

    @State private var isSaved = false

    var body: some View {
        VStack(spacing: 20) {
            ArtworkImage(assetName: playlist.coverImageName, url: playlist.coverImageURL, cornerRadius: 4)
                .frame(width: 220, height: 220)
                .shadow(color: .black.opacity(0.45), radius: 16, y: 10)
                .padding(.top, 8)

            VStack(alignment: .leading, spacing: 12) {
                Text(playlist.description)
                    .font(.circular(.book, size: 15))
                    .foregroundColor(.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.spotifyGreen)
                        .frame(width: 18, height: 18)
                        .overlay(
                            Image(systemName: "waveform")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(Color.primaryBackground)
                        )
                    Text(playlist.ownerName)
                        .font(.circular(.bold, size: 13))
                        .foregroundColor(.textPrimary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("By \(playlist.ownerName)")

                Text(playlist.metaText)
                    .font(.circular(.book, size: 13))
                    .foregroundColor(.textSecondary)

                HStack(spacing: 20) {
                    Button { isSaved.toggle() } label: {
                        Image(systemName: isSaved ? "heart.fill" : "heart")
                            .font(.system(size: 22))
                            .foregroundColor(isSaved ? .spotifyGreen : .textPrimary)
                    }
                    .accessibilityLabel(isSaved ? "Remove from Your Library" : "Save to Your Library")

                    Button { } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18))
                            .foregroundColor(.textPrimary)
                    }
                    .accessibilityLabel("More options")

                    Spacer()

                    Button(action: onPlay) {
                        ZStack {
                            Circle()
                                .fill(Color.spotifyGreen)
                                .frame(width: 56, height: 56)
                            Image(systemName: "play.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color.primaryBackground)
                        }
                    }
                    .accessibilityLabel("Play")
                }
                .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    PlaylistHeaderView(playlist: PlaylistModel(from: Playlist(
        id: "p", title: "Imagine Dragons Mix",
        description: "Tune in to Top Tracks from Imagine Dragons, Alan Walker and many more",
        ownerName: "Spotify", coverImageName: "rock-mix", coverImageURL: nil,
        likesCount: 191165, isDownloaded: false,
        tracks: [Track(id: "1", title: "A", artist: "B", durationSeconds: 13500)]
    )))
    .padding()
    .background(Color.primaryBackground)
    .preferredColorScheme(.dark)
}
