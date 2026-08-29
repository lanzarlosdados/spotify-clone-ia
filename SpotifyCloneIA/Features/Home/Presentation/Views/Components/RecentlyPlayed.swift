import SwiftUI

struct RecentlyPlayed: View {
    let items: [HorizontalCardItem]

    var body: some View {
        HorizontalCardsSectionView(
            title: "Recently played",
            items: items,
            showTitle: true,
            interItemSpacing: 16,
            horizontalPadding: 16,
            verticalPadding: 8,
            showsIndicators: false,
            cardImageSize: .init(width: 94, height: 94),
            cardSize: .init(width: 94, height: 132),
            showItemDescription: false
        )
    }
}

#if DEBUG
struct RecentlyPlayed_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            RecentlyPlayed(items: [
                HorizontalCardItem(imageName: "the-cure", title: "The Cure", description: ""),
                HorizontalCardItem(imageName: "blur", title: "Blur: the best of", description: "")
            ])
            .padding()
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
#endif
