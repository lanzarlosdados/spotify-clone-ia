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
        // Updated to use mock assets: card-slim-1 ... card-slim-6
        cardViewModels = [
            CardSlimViewModel(imageName: "card-slim-7", title: "OK Computer", showNotification: true),
            CardSlimViewModel(imageName: "card-slim-2", title: "Blur: the best of", showNotification: false),
            CardSlimViewModel(imageName: "card-slim-3", title: "Govinda", showNotification: false),
            CardSlimViewModel(imageName: "card-slim-4", title: "Playlist Viper", showNotification: false),
            CardSlimViewModel(imageName: "card-slim-5", title: "The last Dinner Party", showNotification: false),
            CardSlimViewModel(imageName: "card-slim-6", title: "Entering the 3 Body Problem word", showNotification: false),
            CardSlimViewModel(imageName: "card-slim-7", title: "The last Dinner Party", showNotification: false),
            CardSlimViewModel(imageName: "card-slim-8", title: "Entering the 3 Body Problem word", showNotification: false)
        ]
        
        // Debug log for easier debugging.
        print("✅ HomeContentGridViewModel: \(cardViewModels.count) card view models created.")
    }
}

