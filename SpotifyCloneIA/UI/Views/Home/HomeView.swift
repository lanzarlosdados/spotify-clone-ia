import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 32) {
                
                HomeContentGridView()

                RecommendedCardView()
                
                // Sección original (no remover)
                HorizontalCardsSectionView()
                
                // Nueva sección: Recently played - 4 items, imagen 94x94, item 94x132, solo título, spacing 16
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
            Color("#121212").ignoresSafeArea()
            HomeView()
        }
        .preferredColorScheme(.dark)
    }
}
#endif
