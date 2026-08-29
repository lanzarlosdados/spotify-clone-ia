// EpisodePreviewCardView.swift
import SwiftUI

struct EpisodePreviewCardView: View {
    // MARK: - Props
    let title: String
    let subtitle: String
    let dateText: String
    let durationText: String
    let descriptionText: String
    
    // Assets
    let artworkName: String
    let waveformName: String
    let plusIconName: String
    let playIconName: String
    let bulletIconName: String
    let previewIconName: String
    
    // Actions
    var onPlus: () -> Void = {}
    var onPreview: () -> Void = {}
    var onPlay: () -> Void = {}
    
    // MARK: - Layout
    private let cornerRadius: CGFloat = 16
    private let horizontalPadding: CGFloat = 16
    private let headerSpacing: CGFloat = 8
    private let headerTopInset: CGFloat = 16
    private let artworkSize: CGFloat = 120
    private let buttonsHeight: CGFloat = 44
    
    init(
        title: String = "The Black Dahlia Murder Pt.2",
        subtitle: String = "Episode • Solved Murders: True Crime Mysteries",
        dateText: String = "Sep 2023",
        durationText: String = "46 min",
        descriptionText: String = "Elizabeth Short’s gruesome murder is the LAPD’s most infamous unsolved case. But there’s one person who thinks he’s cracked it — the alleged killer’s own son. Today, we reopen the case against Geo…",
        artworkName: String = "solved-murders-podcast",
        waveformName: String = "equalizer-illu",
        plusIconName: String = "plus_circle",
        playIconName: String = "play_icon",
        bulletIconName: String = "ico-24-bullet",
        previewIconName: String = "ico-24-sound-off",
        onPlus: @escaping () -> Void = {},
        onPreview: @escaping () -> Void = {},
        onPlay: @escaping () -> Void = {}
    ) {
        self.title = title
        self.subtitle = subtitle
        self.dateText = dateText
        self.durationText = durationText
        self.descriptionText = descriptionText
        self.artworkName = artworkName
        self.waveformName = waveformName
        self.plusIconName = plusIconName
        self.playIconName = playIconName
        self.bulletIconName = bulletIconName
        self.previewIconName = previewIconName
        self.onPlus = onPlus
        self.onPreview = onPreview
        self.onPlay = onPlay
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Fondo
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.55),
                    Color.episodeCardOverlay.opacity(0.9)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack(alignment: .top) {
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
                    Button(action: onPlus) {
                        Image(plusIconName)
                            .resizable()
                            .frame(width: 28, height: 28)
                    }
                }
                .padding(.top, headerTopInset)
                .padding(.horizontal, horizontalPadding)
                
                // Arte + waveform
                ZStack {
                    Image(waveformName)
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
                .padding(.top, 24)
                
                // Info + descripción
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(dateText)
                            .font(.custom("CircularStd-Bold", size: 12))
                            .foregroundColor(.textPrimary)
                        
                        Image(bulletIconName)
                            .resizable()
                            .frame(width: 12, height: 12)
                            .opacity(0.8)
                        
                        Text(durationText)
                            .font(.custom("CircularStd-Bold", size: 12))
                            .foregroundColor(.textPrimary)
                    }
                    
                    Text(descriptionText)
                        .font(.custom("CircularStd-Book", size: 12))
                        .foregroundColor(.textSecondary)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                // Botones
                HStack(spacing: 12) {
                    Button(action: onPreview) {
                        HStack(spacing: 8) {
                            Image(previewIconName)
                                .resizable()
                                .frame(width: 18, height: 18)
                            Text("Preview episode")
                                .font(.custom("CircularStd-Bold", size: 14))
                        }
                        .foregroundColor(.textPrimary)
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
                    
                    Spacer()
                    
                    Button(action: onPlay) {
                        Image(playIconName)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.bottom, 12)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        EpisodePreviewCardView()
            .padding()
    }
    .preferredColorScheme(.dark)
}
