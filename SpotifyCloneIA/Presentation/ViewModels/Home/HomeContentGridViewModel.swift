import Foundation

// MARK: - HomeContentGridViewModel
/// A view model for managing the content of the `HomeContentGridView`.
/// This class is responsible for providing the data for the slim cards.
@Observable
final class HomeContentGridViewModel {
    
    // MARK: - Properties
    
    /// The list of view models for the slim cards.
    var cardViewModels: [CardSlimViewModel] = []
    
    // MARK: - Initialization
    
    init() {
        setupCardViewModels()
    }
    
    // MARK: - Private Methods
    
    /// Sets up the view models for the slim cards with sample data.
    private func setupCardViewModels() {
        // Sample data based on the Figma design.
        cardViewModels = [
            CardSlimViewModel(imageName: "Avatar", title: "OK Computer", showNotification: true),
            CardSlimViewModel(imageName: "Avatar", title: "Blur: the best of", showNotification: false),
            CardSlimViewModel(imageName: "Avatar", title: "Govinda", showNotification: false),
            CardSlimViewModel(imageName: "Avatar", title: "Playlist Viper", showNotification: false),
            CardSlimViewModel(imageName: "Avatar", title: "The last Dinner Party", showNotification: false),
            CardSlimViewModel(imageName: "Avatar", title: "Entering the 3 Body Problem word", showNotification: false)
        ]
        
        // Debug log for easier debugging.
        print("✅ HomeContentGridViewModel: \(cardViewModels.count) card view models created.")
    }
}
