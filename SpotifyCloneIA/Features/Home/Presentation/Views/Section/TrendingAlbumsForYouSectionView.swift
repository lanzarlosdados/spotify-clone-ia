import SwiftUI

struct TrendingAlbumsForYouSectionView: View {
    let album: TrendingAlbum

    var title: String = "Trending albums for you"
    var headerIconName: String = "ico-24-trande"
    
    // Callbacks
    var onPrev: () -> Void = {}
    var onNext: () -> Void = {}
    var onAdd: () -> Void = {}
    var onPreview: () -> Void = {}
    var onPlay: () -> Void = {}
    var onMore: () -> Void = {}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 8) {
                Image(headerIconName)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(.textSecondary)
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.custom("CircularStd-Bold", size: 16))
                    .foregroundColor(.textSecondary)
                Spacer()
            }
            .padding(.horizontal, 16)
            
            // Card + flechas superpuestas
            ZStack {
                MediaPreviewVideoCardView(
                    title: album.title,
                    subtitle: album.subtitle,
                    previewButtonTitle: "Preview album",
                    backgroundImageName: album.backgroundImageName,
                    artworkName: album.artworkName,
                    plusIconName: "plus_circle",
                    playIconName: "play_icon",
                    previewIconName: "ico-24-sound-off",
                    onAdd: onAdd,
                    onPreview: onPreview,
                    onPlay: onPlay,
                    onMore: onMore
                )
                
                // Flechas
                HStack {
                    arrowButton(systemName: "chevron.left", action: onPrev)
                    Spacer()
                    arrowButton(systemName: "chevron.right", action: onNext)
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    private func arrowButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 44, height: 44) // área táctil 44x44
                .background(Color.black.opacity(0.35))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(systemName == "chevron.left" ? "Previous" : "Next")
        .accessibilityHint(systemName == "chevron.left" ? "Go to previous item" : "Go to next item")
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        TrendingAlbumsForYouSectionView(album: TrendingAlbum(
            title: "Blur (Special Edition)",
            subtitle: "Album • 32 songs, 2 hr 3 min",
            artworkName: "blur-special-edition",
            backgroundImageName: "image-video"
        ))
        .padding()
    }
    .preferredColorScheme(.dark)
}
