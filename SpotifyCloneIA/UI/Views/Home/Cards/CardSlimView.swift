import SwiftUI

// MARK: - CardSlimView
/// A compact card component for displaying content in a grid, based on Figma design.
/// This view is designed to be reusable and configurable through a view model.
struct CardSlimView: View {
    
    // MARK: - Properties
    let viewModel: CardSlimViewModel
    
    // MARK: - Constants
    private let cardHeight: CGFloat = 56
    private let imageSize: CGFloat = 56
    private let cornerRadius: CGFloat = 4
    private let iconSize: CGFloat = 12
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 8) {
            // MARK: - Image
            cardImage
            
            // MARK: - Title and Icon
            cardTitleAndIcon
            
            Spacer()
        }
        .frame(height: cardHeight)
        .background(Color.background)
        .cornerRadius(cornerRadius)
    }
    
    // MARK: - Card Image
    /// Displays the card's image, loaded from assets.
    private var cardImage: some View {
        Image(viewModel.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imageSize, height: imageSize)
            .clipped()
    }
    
    // MARK: - Card Title and Icon
    /// Displays the card's title and an optional icon.
    private var cardTitleAndIcon: some View {
        HStack(spacing: 8) {
            Text(viewModel.title)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
            
            if viewModel.showNotification {
                Circle()
                    .fill(Color.blue)
                    .frame(width: iconSize, height: iconSize)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let mockVM = CardSlimViewModel(
        imageName: "Avatar",
        title: "OK Computer",
        showNotification: true
    )
    
    return CardSlimView(viewModel: mockVM)
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
}
