// MoreLikeSectionView.swift
import SwiftUI

struct MoreLikeSectionView: View {
    let referenceImageName: String
    let referenceTitle: String
    let items: [HorizontalCardItem]
    let onSelect: (HorizontalCardItem) -> Void

    init(
        referenceImageName: String,
        referenceTitle: String,
        items: [HorizontalCardItem],
        onSelect: @escaping (HorizontalCardItem) -> Void = { _ in }
    ) {
        self.referenceImageName = referenceImageName
        self.referenceTitle = referenceTitle
        self.items = items
        self.onSelect = onSelect
    }

    var body: some View {
        HorizontalCardsSectionView(
            title: referenceTitle,
            items: items,
            showTitle: false, // usamos header personalizado
            interItemSpacing: 12,
            horizontalPadding: 16,
            verticalPadding: 8,
            showsIndicators: false,
            cardImageSize: .init(width: 147, height: 147),
            cardSize: .init(width: 147, height: 206),
            showItemDescription: true,
            onSelect: onSelect,
            header: {
                HStack(spacing: 12) {
                    Image(referenceImageName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(4)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("More like:")
                            .font(.custom("CircularStd-Book", size: 16))
                            .foregroundColor(.textSecondary)
                        Text(referenceTitle)
                            .font(.custom("CircularStd-Bold", size: 28))
                            .foregroundColor(.textPrimary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
            }
        )
    }
}

#if DEBUG
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        MoreLikeSectionView(
            referenceImageName: "solved-murders-mini",
            referenceTitle: "The Black Dahlia Murder P…",
            items: [
                HorizontalCardItem(imageName: "more-one", title: "Rock Mix", description: "Blur, The Killers and more"),
                HorizontalCardItem(imageName: "more-two", title: "Pop Mix", description: "Sabrina Carpenter, Chappell Roan")
            ]
        )
    }
    .preferredColorScheme(.dark)
}
#endif
