// MediaPreviewVideoCardView.swift
import SwiftUI

struct MediaPreviewVideoCardView: View {
    // Contenido principal
    let title: String
    let subtitle: String
    let previewButtonTitle: String
    
    // Assets
    let backgroundImageName: String          // Fondo de video/imagen
    let artworkName: String                  // Carátula pequeña arriba a la izquierda
    let plusIconName: String
    let playIconName: String
    let previewIconName: String              // Ícono del botón "Preview"
    
    // Comportamiento
    var onAdd: () -> Void = {}
    var onPreview: () -> Void = {}
    var onPlay: () -> Void = {}
    var onMore: () -> Void = {}
    
    // Layout
    private let cornerRadius: CGFloat = 16
    private let headerSpacing: CGFloat = 8
    private let horizontalPadding: CGFloat = 16
    private let cardHeight: CGFloat = 430
    private let artworkSize: CGFloat = 64
    private let buttonsHeight: CGFloat = 44
    
    init(
        title: String = "Blur (Special Edition)",
        subtitle: String = "Album • 32 songs, 2 hr 3 min",
        previewButtonTitle: String = "Preview album",
        backgroundImageName: String = "image-video",
        artworkName: String = "blur-special-edition",
        plusIconName: String = "plus_circle",
        playIconName: String = "play_icon",
        previewIconName: String = "ico-24-share",
        onAdd: @escaping () -> Void = {},
        onPreview: @escaping () -> Void = {},
        onPlay: @escaping () -> Void = {},
        onMore: @escaping () -> Void = {}
    ) {
        self.title = title
        self.subtitle = subtitle
        self.previewButtonTitle = previewButtonTitle
        self.backgroundImageName = backgroundImageName
        self.artworkName = artworkName
        self.plusIconName = plusIconName
        self.playIconName = playIconName
        self.previewIconName = previewIconName
        self.onAdd = onAdd
        self.onPreview = onPreview
        self.onPlay = onPlay
        self.onMore = onMore
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Fondo de imagen (video)
            Image(backgroundImageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            
            // Scrims para legibilidad (arriba y abajo)
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.black.opacity(0.55), location: 0.0),
                    .init(color: Color.black.opacity(0.25), location: 0.35),
                    .init(color: Color.black.opacity(0.15), location: 0.6),
                    .init(color: Color.black.opacity(0.55), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .allowsHitTesting(false)
            
            VStack(alignment: .leading, spacing: 0) {
                header
                Spacer()
                bottomActions
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.top, 16)
            .padding(.bottom, 16)
        }
        .frame(height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    // MARK: - Subviews
    
    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(artworkName)
                .resizable()
                .frame(width: artworkSize, height: artworkSize)
                .cornerRadius(8)
                .shadow(radius: 3, y: 2)
            
            VStack(alignment: .leading, spacing: headerSpacing) {
                Text(title)
                    .font(.custom("CircularStd-Bold", size: 22))
                    .foregroundColor(.textPrimary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(subtitle)
                    .font(.custom("CircularStd-Book", size: 13))
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            Spacer(minLength: 12)
            Button(action: onAdd) {
                Image(plusIconName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
            }
        }
    }
    
    private var bottomActions: some View {
        HStack(spacing: 12) {
            Button(action: onPreview) {
                HStack(spacing: 8) {
                    Image(previewIconName)
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text(previewButtonTitle)
                        .font(.custom("CircularStd-Bold", size: 14))
                }
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 16)
                .frame(height: buttonsHeight)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.35))
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
            }
            
            Spacer()
            
            // Botón "más" opcional para coincidir con el mock
            Button(action: onMore) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 44, height: 44)
                    .background(Color.black.opacity(0.35))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            
            Button(action: onPlay) {
                Image(playIconName)
                    .resizable()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                    .background(
                        Circle().fill(Color.white)
                            .shadow(color: .black.opacity(0.3), radius: 6, y: 2)
                    )
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.15), lineWidth: 0) // para mantener misma API visual
                    )
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        MediaPreviewVideoCardView()
            .padding()
    }
    .preferredColorScheme(.dark)
}
