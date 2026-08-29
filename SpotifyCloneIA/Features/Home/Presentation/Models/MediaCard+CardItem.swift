import Foundation

// MARK: - MediaCard -> view-layer items
/// Maps the `MediaCard` domain entity into the item types the Home views expect.
extension MediaCard {

    /// Item for the horizontal card rows.
    var horizontalCardItem: HorizontalCardItem {
        HorizontalCardItem(imageName: imageName, title: title, description: subtitle)
    }
}

extension Array where Element == MediaCard {
    var horizontalCardItems: [HorizontalCardItem] {
        map { $0.horizontalCardItem }
    }
}

// MARK: - ContentGridItem -> CardSlimViewModel
extension ContentGridItem {
    var cardSlimViewModel: CardSlimViewModel {
        CardSlimViewModel(imageName: imageName, title: title, showNotification: hasNotification)
    }
}
