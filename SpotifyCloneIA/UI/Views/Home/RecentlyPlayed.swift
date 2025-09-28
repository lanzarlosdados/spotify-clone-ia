import SwiftUI

struct RecentlyPlayed: View {
    var body: some View {
        HorizontalCardsSectionView(
            title: "Recently played",
            items: [
                HorizontalCardItem(imageName: "the-cure", title: "The Cure", description: ""),
                HorizontalCardItem(imageName: "arctic-monkeys", title: "The View From The Afternoon", description: ""),
                HorizontalCardItem(imageName: "beastie-boys", title: "Sabotage", description: ""),
                HorizontalCardItem(imageName: "blur", title: "Blur: the best of", description: "")
            ],
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
            RecentlyPlayed()
                .padding()
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
#endif
