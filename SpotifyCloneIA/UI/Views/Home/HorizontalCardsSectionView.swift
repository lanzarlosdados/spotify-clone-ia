import SwiftUI

struct HorizontalCardItem: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
    
    init(
        imageName: String,
        title: String,
        description: String
    ) {
        self.imageName = imageName
        self.title = title
        self.description = description
    }
}

struct HorizontalCardsSectionView<Header: View>: View {
    
    // MARK: - Configuración
    let title: String
    let items: [HorizontalCardItem]
    let showTitle: Bool
    let interItemSpacing: CGFloat
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let showsIndicators: Bool
    let onSelect: (HorizontalCardItem) -> Void
    
    // Configuración para cada tarjeta
    let cardImageSize: CGSize
    let cardSize: CGSize
    let showItemDescription: Bool
    
    // Header compuesto (no opcional)
    private let headerContent: () -> Header
    private let hasCustomHeader: Bool
    
    // MARK: - Inits
    
    // Init principal con header inyectable
    init(
        title: String = "Your top mixes",
        items: [HorizontalCardItem],
        showTitle: Bool = true,
        interItemSpacing: CGFloat = 16,
        horizontalPadding: CGFloat = 16,
        verticalPadding: CGFloat = 8,
        showsIndicators: Bool = false,
        cardImageSize: CGSize = .init(width: 147, height: 147),
        cardSize: CGSize = .init(width: 147, height: 206),
        showItemDescription: Bool = true,
        onSelect: @escaping (HorizontalCardItem) -> Void = { _ in },
        @ViewBuilder header: @escaping () -> Header
    ) {
        self.title = title
        self.items = items
        self.showTitle = showTitle
        self.interItemSpacing = interItemSpacing
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.showsIndicators = showsIndicators
        self.cardImageSize = cardImageSize
        self.cardSize = cardSize
        self.showItemDescription = showItemDescription
        self.onSelect = onSelect
        self.headerContent = header
        self.hasCustomHeader = true
    }
    
    // Conveniencia: sin header custom -> usa Text(title)
    init(
        title: String = "Your top mixes",
        items: [HorizontalCardItem] = HorizontalCardsSectionView.sampleItems,
        showTitle: Bool = true,
        interItemSpacing: CGFloat = 16,
        horizontalPadding: CGFloat = 16,
        verticalPadding: CGFloat = 8,
        showsIndicators: Bool = false,
        cardImageSize: CGSize = .init(width: 147, height: 147),
        cardSize: CGSize = .init(width: 147, height: 206),
        showItemDescription: Bool = true,
        onSelect: @escaping (HorizontalCardItem) -> Void = { _ in }
    ) where Header == EmptyView {
        self.title = title
        self.items = items
        self.showTitle = showTitle
        self.interItemSpacing = interItemSpacing
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.showsIndicators = showsIndicators
        self.cardImageSize = cardImageSize
        self.cardSize = cardSize
        self.showItemDescription = showItemDescription
        self.onSelect = onSelect
        self.headerContent = { EmptyView() }
        self.hasCustomHeader = false
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Si hay header custom, úsalo; si no, usa el Text(title) existente.
            if hasCustomHeader {
                headerContent()
                    .padding(.horizontal, horizontalPadding)
            } else if showTitle {
                Text(title)
                    .font(.custom("CircularStd-Bold", size: 22))
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, horizontalPadding)
            }
            
            ScrollView(.horizontal, showsIndicators: showsIndicators) {
                HStack(spacing: interItemSpacing) {
                    ForEach(items) { item in
                        HorizontalCardView(
                            imageName: item.imageName,
                            title: item.title,
                            description: item.description,
                            imageSize: cardImageSize,
                            cardSize: cardSize,
                            showDescription: showItemDescription
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onSelect(item)
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)
            }
        }
        .padding(.vertical, verticalPadding)
    }
}


// MARK: - Mocks
private extension HorizontalCardsSectionView {
    static var sampleItems: [HorizontalCardItem] {
        [
            HorizontalCardItem(imageName: "rock-mix", title: "Rock Mix", description: "Blur, The Killers, Kula Shaker and more"),
            HorizontalCardItem(imageName: "pop-mix", title: "Pop Mix", description: "Sabrina Carpenter, Chappell Roan, Olivia Rodrigo"),
            HorizontalCardItem(imageName: "upbeat-mix", title: "Upbeat Mix", description: "The Stokes, Chappell Roan, Talking Heads and more")
        ]
    }
}

#if DEBUG
struct HorizontalCardsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview con init de conveniencia
            HorizontalCardsSectionView<EmptyView>()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            
            // Preview con header compuesto (similar a tus capturas)
            HorizontalCardsSectionView(
                title: "The Black Dahlia Murder P…",
                items: HorizontalCardsSectionView<EmptyView>.sampleItems,
                showTitle: false, // lo maneja el header custom
                interItemSpacing: 12,
                horizontalPadding: 20,
                verticalPadding: 8,
                showsIndicators: false,
                cardImageSize: .init(width: 147, height: 147),
                cardSize: .init(width: 147, height: 206),
                showItemDescription: true,
                onSelect: { item in
                    print("👆 Tapped on: \(item.title)")
                },
                header: {
                    HStack(spacing: 12) {
                        Image("episode-one")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(4)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("More like:")
                                .font(.custom("CircularStd-Book", size: 16))
                                .foregroundColor(.textSecondary)
                            Text("The Black Dahlia Murder P…")
                                .font(.custom("CircularStd-Bold", size: 28))
                                .foregroundColor(.textPrimary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                }
            )
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        }
    }
}
#endif
