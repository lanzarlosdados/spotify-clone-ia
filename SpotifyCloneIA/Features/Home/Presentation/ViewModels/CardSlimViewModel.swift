import Foundation

// MARK: - CardSlimViewModel
/// A view model for configuring the `CardSlimView`.
/// This struct holds the data necessary to display a slim card, such as title and image name.
struct CardSlimViewModel: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let showNotification: Bool
}
