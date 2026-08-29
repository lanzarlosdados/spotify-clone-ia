import SwiftUI

struct JumpBackInSectionView: View {
    let title: String
    let items: [HorizontalCardItem]
    let onSelect: (HorizontalCardItem) -> Void

    init(
        title: String = "Jump back in",
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
        JumpBackInSectionView(items: [
            HorizontalCardItem(imageName: "jump-one", title: "Three Imaginary Boys", description: "1979 • Album"),
            HorizontalCardItem(imageName: "jump-two", title: "Alternative 80s", description: "Playlist • Spotify")
        ])
    }
    .preferredColorScheme(.dark)
}
#endif
