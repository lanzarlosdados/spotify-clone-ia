import SwiftUI

// MARK: - PlayerView
/// Full-screen "now playing" screen. Presented as a `fullScreenCover`.
struct PlayerView: View {

    // Using `let` for the @Observable view model as per state management rules.
    let viewModel: PlayerViewModel

    @Environment(\.dismiss) private var dismiss
    @State private var isDragging = false
    @State private var dragFraction: Double = 0

    init(viewModel: PlayerViewModel? = nil) {
        self.viewModel = viewModel ?? PlayerCompositionRoot.shared.makePlayerViewModel()
    }

    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar

                if let track = viewModel.track {
                    Spacer(minLength: 12)
                    ArtworkImage(assetName: track.coverImageName, url: track.coverImageURL, cornerRadius: 6)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                    Spacer(minLength: 24)
                    trackInfo(track)
                    seekBar
                    controls
                    bottomBar
                    lyricsCard
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    Text(error)
                        .font(.circular(.book, size: 14))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    Spacer()
                    ProgressView().tint(.spotifyGreen)
                    Spacer()
                }
            }
            .padding(.horizontal, 24)
        }
        // The player surface is always dark (matches the design + the always-dark
        // `primaryBackground`); pin it so adaptive colors resolve correctly even
        // when the OS is in light mode.
        .preferredColorScheme(.dark)
        .task { await viewModel.load() }
    }

    // MARK: - Top bar

    private var topBar: some View {
        HStack(spacing: 12) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.down")
                    .font(.system(size: 20, weight: .semibold))
            }
            .accessibilityLabel("Close player")

            Spacer()

            VStack(spacing: 2) {
                Text(viewModel.contextLabel)
                    .font(.circular(.book, size: 10))
                    .tracking(1)
                    .foregroundColor(.textSecondary)
                if !viewModel.contextTitle.isEmpty {
                    Text(viewModel.contextTitle)
                        .font(.circular(.bold, size: 13))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Button { } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .bold))
            }
            .accessibilityLabel("More options")
        }
        .foregroundColor(.textPrimary)
        .frame(height: 44)
    }

    // MARK: - Track info + like

    private func trackInfo(_ track: Track) -> some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(track.title)
                    .font(.circular(.bold, size: 22))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                Text(track.artist)
                    .font(.circular(.book, size: 15))
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Button { viewModel.toggleLike() } label: {
                Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                    .font(.system(size: 22))
                    .foregroundColor(viewModel.isLiked ? .spotifyGreen : .textPrimary)
            }
            .accessibilityLabel(viewModel.isLiked ? "Remove from Liked Songs" : "Save to Liked Songs")
        }
        .padding(.bottom, 4)
    }

    // MARK: - Seek bar

    private var seekBar: some View {
        let fraction = isDragging ? dragFraction : viewModel.progress

        return VStack(spacing: 6) {
            GeometryReader { geo in
                let width = geo.size.width
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.textSecondary.opacity(0.3))
                        .frame(height: 4)
                    Capsule()
                        .fill(Color.textPrimary)
                        .frame(width: max(0, width * fraction), height: 4)
                    Circle()
                        .fill(Color.textPrimary)
                        .frame(width: 12, height: 12)
                        .offset(x: max(0, min(width - 12, width * fraction - 6)))
                }
                .frame(maxHeight: .infinity, alignment: .center)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isDragging = true
                            dragFraction = min(max(0, value.location.x / width), 1)
                        }
                        .onEnded { _ in
                            viewModel.seek(toFraction: dragFraction)
                            isDragging = false
                        }
                )
            }
            .frame(height: 16)

            HStack {
                Text(isDragging
                     ? PlayerViewModel.timeString(dragFraction * secondsForFraction)
                     : viewModel.elapsedText)
                Spacer()
                Text(viewModel.durationText)
            }
            .font(.circular(.book, size: 11))
            .foregroundColor(.textSecondary)
        }
        .padding(.top, 12)
    }

    /// Duration in seconds, used to render the label while scrubbing.
    private var secondsForFraction: Double {
        guard let seconds = viewModel.track?.durationSeconds else { return 0 }
        return Double(seconds)
    }

    // MARK: - Transport controls

    private var controls: some View {
        HStack {
            Button { viewModel.toggleShuffle() } label: {
                Image(systemName: "shuffle")
                    .font(.system(size: 18))
                    .foregroundColor(viewModel.isShuffled ? .spotifyGreen : .textPrimary)
            }
            .accessibilityLabel("Shuffle")
            .accessibilityValue(viewModel.isShuffled ? "On" : "Off")

            Spacer()

            Button { viewModel.previous() } label: {
                Image(systemName: "backward.fill").font(.system(size: 28))
            }
            .accessibilityLabel("Previous track")

            Spacer()

            Button { viewModel.togglePlayPause() } label: {
                ZStack {
                    Circle().fill(Color.textPrimary).frame(width: 64, height: 64)
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 26))
                        .foregroundColor(Color.primaryBackground)
                }
            }
            .accessibilityLabel(viewModel.isPlaying ? "Pause" : "Play")

            Spacer()

            Button { viewModel.next() } label: {
                Image(systemName: "forward.fill").font(.system(size: 28))
            }
            .accessibilityLabel("Next track")

            Spacer()

            Button { viewModel.cycleRepeat() } label: {
                Image(systemName: viewModel.repeatMode == .track ? "repeat.1" : "repeat")
                    .font(.system(size: 18))
                    .foregroundColor(viewModel.repeatMode == .off ? .textPrimary : .spotifyGreen)
            }
            .accessibilityLabel("Repeat")
            .accessibilityValue(repeatAccessibilityValue)
        }
        .foregroundColor(.textPrimary)
        .padding(.top, 20)
    }

    private var repeatAccessibilityValue: String {
        switch viewModel.repeatMode {
        case .off: return "Off"
        case .context: return "Repeat all"
        case .track: return "Repeat one"
        }
    }

    // MARK: - Bottom bar

    private var bottomBar: some View {
        HStack {
            Button { } label: {
                Image(systemName: "hifispeaker.and.homepod")
            }
            .accessibilityLabel("Connect to a device")

            Spacer()

            Button { } label: {
                Image(systemName: "square.and.arrow.up")
            }
            .accessibilityLabel("Share")
        }
        .font(.system(size: 16))
        .foregroundColor(.textSecondary)
        .padding(.top, 24)
    }

    // MARK: - Lyrics teaser

    private var lyricsCard: some View {
        HStack {
            Text("Lyrics")
                .font(.circular(.bold, size: 18))
                .foregroundColor(.textPrimary)
            Spacer()
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 14))
                .foregroundColor(.textPrimary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.lyricsCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.top, 20)
        .padding(.bottom, 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Lyrics")
        .accessibilityHint("Opens full lyrics")
    }
}

#Preview {
    PlayerView()
        .preferredColorScheme(.dark)
}
