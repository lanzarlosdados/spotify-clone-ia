import SwiftUI

// MARK: - HomeContentGridView
/// Componente que muestra una grilla de contenido para la pantalla Home.
/// Aplicando reglas: SwiftUI, Simple solutions, Clean codebase, Debug logs & comments
struct HomeContentGridView: View {

    // MARK: - Properties
    @State private var viewModel = HomeContentGridViewModel()

    // MARK: - Body
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
            ForEach(viewModel.cardViewModels) { cardViewModel in
                CardSlimView(viewModel: cardViewModel)
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview
#Preview {
    HomeContentGridView()
        .background(Color.black)
        .preferredColorScheme(.dark)
}
