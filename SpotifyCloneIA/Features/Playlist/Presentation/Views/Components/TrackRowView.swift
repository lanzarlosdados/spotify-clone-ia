import SwiftUI

// MARK: - TrackRowView
/// A single row in the playlist track list: artwork, title, "LYRICS" badge +
/// artist, and an overflow menu button.
struct TrackRowView: View {

    let track: TrackRowModel
    var onMore: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            ArtworkImage(assetName: track.coverImageName, url: track.coverImageURL)
                .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 4) {
                Text(track.title)
                    .font(.circular(.bold, size: 16))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text("LYRICS")
                        .font(.circular(.bold, size: 9))
                        .tracking(0.5)
                        .foregroundColor(.textSecondary)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.textSecondary, lineWidth: 1)
                        )

                    if track.isExplicit {
                        Image(systemName: "e.square.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.textSecondary)
                    }

                    Text(track.artist)
                        .font(.circular(.book, size: 13))
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Button(action: onMore) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16))
                    .foregroundColor(.textSecondary)
            }
            .accessibilityLabel("More options for \(track.title)")
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(track.title), \(track.artist)")
    }
}

#Preview {
    VStack(spacing: 0) {
        TrackRowView(track: TrackRowModel(from: Track(
            id: "1", title: "Believer", artist: "Imagine Dragons",
            coverImageName: "arctic-monkeys", durationSeconds: 204
        )))
        TrackRowView(track: TrackRowModel(from: Track(
            id: "2", title: "Taki Taki", artist: "DJ Snake feat Selena Gomez",
            coverImageName: "pop-mix", durationSeconds: 232, isExplicit: true
        )))
    }
    .padding()
    .background(Color.primaryBackground)
}
