import SwiftUI

struct EpisodesForYouSectionView: View {
    let title: String
    let items: [HorizontalCardItem]
    let onSelect: (HorizontalCardItem) -> Void

    init(
        title: String = "Episodes for you",
        items: [HorizontalCardItem] = [
            HorizontalCardItem(imageName: "episode-one", title: "4th of July Special", description: "Go! My Favorite Sports Team"),
            HorizontalCardItem(imageName: "episode-two", title: "The Last Great Debate", description: "Distractible"),
            HorizontalCardItem(imageName: "episode-three", title: "Everyone", description: "The Dog")
        ],
        onSelect: @escaping (HorizontalCardItem) -> Void = { _ in }
    ) {
        self.title = title
        self.items = items
        self.onSelect = onSelect
    }

    var body: some View {
        HorizontalCardsSectionView(
            title: title,
            items: items,
            showTitle: true,
            interItemSpacing: 16,
            horizontalPadding: 16,
            verticalPadding: 8,
            showsIndicators: false,
            cardImageSize: .init(width: 147, height: 147),
            cardSize: .init(width: 147, height: 206),
            showItemDescription: true,
            onSelect: onSelect
        )
    }
}

#if DEBUG
struct EpisodesForYouSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            EpisodesForYouSectionView()
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
#endif
