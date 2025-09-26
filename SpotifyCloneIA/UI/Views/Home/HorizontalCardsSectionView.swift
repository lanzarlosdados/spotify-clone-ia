import SwiftUI

struct HorizontalCardItem: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
}

struct HorizontalCardsSectionView: View {
    
    // MARK: - Configuración
    let title: String
    let items: [HorizontalCardItem]
    let showTitle: Bool
    let interItemSpacing: CGFloat
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let showsIndicators: Bool
    let onSelect: (HorizontalCardItem) -> Void
    
    // MARK: - Inits
    
    init(
        title: String = "Your top mixes",
        items: [HorizontalCardItem],
        showTitle: Bool = true,
        interItemSpacing: CGFloat = 16,
        horizontalPadding: CGFloat = 16,
        verticalPadding: CGFloat = 8,
        showsIndicators: Bool = false,
        onSelect: @escaping (HorizontalCardItem) -> Void = { _ in }
    ) {
        self.title = title
        self.items = items
        self.showTitle = showTitle
        self.interItemSpacing = interItemSpacing
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.showsIndicators = showsIndicators
        self.onSelect = onSelect
    }
    
    init() {
        self.init(
            title: "Your top mixes",
            items: HorizontalCardsSectionView.sampleItems
        )
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if showTitle {
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
                            description: item.description
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
    static let sampleItems: [HorizontalCardItem] = [
        HorizontalCardItem(imageName: "rock-mix", title: "Rock Mix", description: "Blur, The Killers, Kula Shaker and more"),
        HorizontalCardItem(imageName: "pop-mix", title: "Pop Mix", description: "Sabrina Carpenter, Chappell Roan, Olivia Rodrigo"),
        HorizontalCardItem(imageName: "upbeat-mix", title: "Upbeat Mix", description: "The Stokes, Chappell Roan, Talking Heads and more")
    ]
}

#if DEBUG
struct HorizontalCardsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview con init de conveniencia
            HorizontalCardsSectionView()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            
            // Preview con datos inyectados y onSelect
            HorizontalCardsSectionView(
                title: "Tus favoritos",
                items: HorizontalCardsSectionView.sampleItems,
                showTitle: true,
                interItemSpacing: 12,
                horizontalPadding: 20,
                verticalPadding: 8,
                showsIndicators: false,
                onSelect: { item in
                    print("👆 Tapped on: \(item.title)")
                }
            )
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        }
    }
}
#endif
