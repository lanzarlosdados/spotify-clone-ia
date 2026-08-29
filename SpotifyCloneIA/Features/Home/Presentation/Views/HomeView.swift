import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 32) {
                HomeContentGridView()
                RecommendedCardView()
                HorizontalCardsSectionView()
                RecentlyPlayed()
                EpisodesForYouSectionView()

                MoreLikeSectionView(
                    referenceImageName: "solved-murders-mini",
                    referenceTitle: "The Black Dahlia Murder P…",
                    items: MoreLikeSectionView.sampleItems
                )

                JumpBackInSectionView()
                RecommendedForTodaySectionView()

                MediaPreviewCardView(
                    previewButtonTitle: "Preview episode",
                    kind: .episode
                )

                TrendingAlbumsForYouSectionView()

                Spacer()
                    .frame(height: 151)
            }
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()
            HomeView()
        }
        .preferredColorScheme(.dark)
    }
}
#endif
