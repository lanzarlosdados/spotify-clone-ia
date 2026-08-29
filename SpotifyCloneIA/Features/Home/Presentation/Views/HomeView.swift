import SwiftUI

// MARK: - HomeView
/// Main view for the Home screen. Renders every section from the `HomeFeed`
/// provided by `HomeViewModel`.
struct HomeView: View {

    // MARK: - Properties

    let viewModel: HomeViewModel

    /// Temporary entry point to the Player until a real "now playing" bar exists.
    @State private var isPlayerPresented = false

    // MARK: - Initialization

    init(viewModel: HomeViewModel? = nil) {
        self.viewModel = viewModel ?? HomeCompositionRoot.shared.makeHomeViewModel()
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()

            if let feed = viewModel.feed {
                content(feed)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .font(.circular(.book, size: 14))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(32)
            } else {
                ProgressView()
                    .tint(.spotifyGreen)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPlayerPresented = true
                } label: {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(.textPrimary)
                }
                .accessibilityLabel("Open player")
            }
        }
        .fullScreenCover(isPresented: $isPlayerPresented) {
            PlayerCompositionRoot.shared.makePlayerView()
        }
        .task {
            await viewModel.load()
        }
    }

    // MARK: - Content

    private func content(_ feed: HomeFeed) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 32) {
                HomeContentGridView(items: feed.contentGrid)

                RecommendedCardView(release: feed.newRelease)

                HorizontalCardsSectionView(
                    title: "Your top mixes",
                    items: feed.yourTopMixes.horizontalCardItems
                )

                RecentlyPlayed(items: feed.recentlyPlayed.horizontalCardItems)

                EpisodesForYouSectionView(items: feed.episodesForYou.horizontalCardItems)

                MoreLikeSectionView(
                    referenceImageName: feed.moreLikeReference.imageName,
                    referenceTitle: feed.moreLikeReference.title,
                    items: feed.moreLike.horizontalCardItems
                )

                JumpBackInSectionView(items: feed.jumpBackIn.horizontalCardItems)

                RecommendedForTodaySectionView(items: feed.recommendedForToday.horizontalCardItems)

                MediaPreviewCardView(
                    title: feed.episodePreview.title,
                    subtitle: feed.episodePreview.subtitle,
                    dateText: feed.episodePreview.dateText,
                    durationText: feed.episodePreview.durationText,
                    descriptionText: feed.episodePreview.descriptionText,
                    previewButtonTitle: feed.episodePreview.previewButtonTitle,
                    artworkName: feed.episodePreview.artworkName,
                    kind: .episode
                )

                TrendingAlbumsForYouSectionView(album: feed.trendingAlbum)

                Spacer()
                    .frame(height: 151)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    NavigationStack {
        HomeView()
    }
    .preferredColorScheme(.dark)
}
#endif
