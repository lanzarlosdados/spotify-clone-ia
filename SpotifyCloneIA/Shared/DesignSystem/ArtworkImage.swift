import SwiftUI
import UIKit

// MARK: - ArtworkImage
/// Cross-feature artwork view (Player + Playlist). Resolves an image from a local
/// asset-catalog name first, then a remote URL, with a consistent placeholder.
/// The caller sets the frame; the image fills and clips to a rounded rect.
struct ArtworkImage: View {

    let assetName: String?
    let url: URL?
    var cornerRadius: CGFloat = 4

    var body: some View {
        content
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    @ViewBuilder
    private var content: some View {
        if let assetName, !assetName.isEmpty, UIImage(named: assetName) != nil {
            Image(assetName).resizable()
        } else if let url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                case .failure:
                    placeholder
                case .empty:
                    placeholder.redacted(reason: .placeholder)
                @unknown default:
                    placeholder
                }
            }
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        Rectangle()
            .fill(Color.cardBackground)
            .overlay(
                Image(systemName: "music.note")
                    .font(.system(size: 22))
                    .foregroundColor(.textSecondary)
            )
    }
}

#Preview {
    HStack(spacing: 16) {
        ArtworkImage(assetName: "rock-mix", url: nil)
            .frame(width: 120, height: 120)
        ArtworkImage(assetName: nil, url: nil)
            .frame(width: 120, height: 120)
    }
    .padding()
    .background(Color.primaryBackground)
}
