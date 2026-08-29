import SwiftUI

struct RecommendedForTodaySectionView: View {
    let title: String
    let items: [HorizontalCardItem]
    let onSelect: (HorizontalCardItem) -> Void

    init(
        title: String = "Raccomanded for today",
        items: [HorizontalCardItem],
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
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        RecommendedForTodaySectionView(items: [
            HorizontalCardItem(imageName: "today-one", title: "Unreal Unearth", description: "Album • Hozier"),
            HorizontalCardItem(imageName: "today-two", title: "Sinner", description: "Song • The Last Dinner Party")
        ])
    }
    .preferredColorScheme(.dark)
}
#endif
