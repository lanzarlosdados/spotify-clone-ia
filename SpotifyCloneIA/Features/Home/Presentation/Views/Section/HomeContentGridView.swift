import SwiftUI

// MARK: - HomeContentGridView
/// A 2-column grid of compact cards for the top of the Home screen.
struct HomeContentGridView: View {

    // MARK: - Properties
    let items: [ContentGridItem]

    // MARK: - Body
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
            ForEach(items) { item in
                CardSlimView(viewModel: item.cardSlimViewModel)
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview
#Preview {
    HomeContentGridView(items: [
        ContentGridItem(id: "1", imageName: "card-slim-1", title: "OK Computer", hasNotification: true),
        ContentGridItem(id: "2", imageName: "card-slim-2", title: "Blur: the best of", hasNotification: false)
    ])
    .background(Color.backgroundApp)
}
