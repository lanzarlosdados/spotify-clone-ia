// MediaPreviewCardView.swift
import SwiftUI

enum MediaKind {
    case episode
    case video
    case album
}

struct MediaPreviewCardView: View {
    // MARK: - Configuración de contenido (genérica)
    let title: String
    let subtitle: String        // Ej: "Episode • ..." o "Video • ..."
    let dateText: String        // Ej: "Sep 2023"
    let durationText: String    // Ej: "46 min"
    let descriptionText: String
    let previewButtonTitle: String   // Texto dinámico para el botón "Preview"
    
    // MARK: - Assets
    let artworkName: String                 // Portada o thumbnail
    let backgroundIllustrationName: String  // Fondo decorativo (onda, etc.)
    let plusIconName: String
    let playIconName: String
    let bulletIconName: String
    let previewIconName: String
    
    // MARK: - Comportamiento
    let kind: MediaKind
    var onAdd: () -> Void = {}
    var onPreview: () -> Void = {}
    var onPlay: () -> Void = {}
    var onMore: () -> Void = {} // NUEVO
    
    // MARK: - Constantes de layout
    private let cornerRadius: CGFloat = 16
    private let horizontalPadding: CGFloat = 16
    private let headerSpacing: CGFloat = 8
    private let artworkSize: CGFloat = 120
    private let buttonsHeight: CGFloat = 44
    private let cardHeight: CGFloat = 430 // Altura solicitada
    
    // Paddings top/bottom para el contenido (se respetan y el resto del alto se reparte en Spacers)
    private let contentTopPadding: CGFloat = 16
    private let contentBottomPadding: CGFloat = 12
    
    // Base color (hex 324B5C)
    private let baseCardColor = Color(red: 50/255, green: 75/255, blue: 92/255)
    // Tono un poco más oscuro para dar profundidad en el gradiente
    private let darkerCardColor = Color(red: 38/255, green: 57/255, blue: 70/255)
    
    init(
        title: String = "The Black Dahlia Murder Pt.2",
        subtitle: String = "Episode • Solved Murders: True Crime Mysteries",
        dateText: String = "Sep 2023",
        durationText: String = "46 min",
        descriptionText: String = "Elizabeth Short’s gruesome murder is the LAPD’s most infamous unsolved case. But there’s one person who thinks he’s cracked it — the alleged killer’s own son. Today, we reopen the case against Geo…",
        previewButtonTitle: String = "Preview",
        artworkName: String = "solved-murders-podcast",
        backgroundIllustrationName: String = "equalizer-illu",
        plusIconName: String = "plus_circle",
        playIconName: String = "play_icon",
        bulletIconName: String = "ico-24-bullet",
        previewIconName: String = "ico-24-sound-off",
        kind: MediaKind = .episode,
        onAdd: @escaping () -> Void = {},
        onPreview: @escaping () -> Void = {},
        onPlay: @escaping () -> Void = {},
        onMore: @escaping () -> Void = {} // NUEVO
    ) {
        self.title = title
        self.subtitle = subtitle
        self.dateText = dateText
        self.durationText = durationText
        self.descriptionText = descriptionText
        self.previewButtonTitle = previewButtonTitle
        self.artworkName = artworkName
        self.backgroundIllustrationName = backgroundIllustrationName
        self.plusIconName = plusIconName
        self.playIconName = playIconName
        self.bulletIconName = bulletIconName
        self.previewIconName = previewIconName
        self.kind = kind
        self.onAdd = onAdd
        self.onPreview = onPreview
        self.onPlay = onPlay
        self.onMore = onMore
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Fondo con el color 324B5C y un ligero gradiente para profundidad
            LinearGradient(
                gradient: Gradient(colors: [
                    baseCardColor,
                    darkerCardColor
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Contenido con "space equals" entre grupos
            VStack(alignment: .leading, spacing: 0) {
                headerGroup
                Spacer(minLength: 0) // 1er espacio flexible
                artworkGroup
                Spacer(minLength: 0) // 2do espacio flexible
                infoAndActionsGroup
            }
            .padding(.top, contentTopPadding)
            .padding(.bottom, contentBottomPadding)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .frame(height: cardHeight) // Ocupa todo el alto de la card
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    // MARK: - Subviews (grupos)
    
    private var headerGroup: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: headerSpacing) {
                Text(title)
                    .font(.custom("CircularStd-Bold", size: 22))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(subtitle)
                    .font(.custom("CircularStd-Book", size: 13))
                    .foregroundColor(.white)
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
        .padding(.horizontal, horizontalPadding)
    }
    
    private var artworkGroup: some View {
        ZStack {
            Image(backgroundIllustrationName)
                .resizable()
                .scaledToFit()
                .opacity(0.6)
                .frame(maxWidth: .infinity, maxHeight: 90)
                .padding(.horizontal, horizontalPadding)
            
            Image(artworkName)
                .resizable()
                .frame(width: artworkSize, height: artworkSize)
                .cornerRadius(6)
                .shadow(radius: 4, y: 2)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var infoAndActionsGroup: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Info (fecha • duración)
            HStack(spacing: 8) {
                Text(dateText)
                    .font(.custom("CircularStd-Bold", size: 12))
                    .foregroundColor(.white)
                
                Image(bulletIconName)
                    .resizable()
                    .frame(width: 12, height: 12)
                    .opacity(0.8)
                
                Text(durationText)
                    .font(.custom("CircularStd-Bold", size: 12))
                    .foregroundColor(.white)
            }
            
            // Descripción
            Text(descriptionText)
                .font(.custom("CircularStd-Book", size: 12))
                .foregroundColor(.white)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
            
            // Acciones
            HStack(spacing: 12) {
                Button(action: onPreview) {
                    HStack(spacing: 8) {
                        Image(previewIconName)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 18, height: 18)
                            .foregroundColor(.white)
                        Text(previewButtonTitle)
                            .font(.custom("CircularStd-Bold", size: 14))
                            .lineLimit(1)
                            .minimumScaleFactor(0.9)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .frame(height: buttonsHeight)
                    .background(
                        Capsule()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            .background(
                                Capsule().fill(Color.white.opacity(0.08))
                            )
                    )
                }
                .layoutPriority(0)
                
                Spacer(minLength: 8)
                
                HStack(spacing: 12) {
                    Button(action: onMore) {
                        Image("ico-24-bullet")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 18, height: 18)
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
                    }
                }
                .layoutPriority(1)
            }
        }
        .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    ZStack {
        VStack(spacing: 24) {
            MediaPreviewCardView(
                title: "Blur (Special Edition)",
                subtitle: "Album • 32 songs, 2 hr 3 min",
                dateText: "2024",
                durationText: "2 hr 3 min",
                descriptionText: "A special edition packed with remastered tracks and exclusive content.",
                previewButtonTitle: "Preview album",
                artworkName: "blur-special-edition",
                kind: .album
            )
        }
        .padding()
    }
    .preferredColorScheme(.light)
}
