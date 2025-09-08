import SwiftUI

// MARK: - CustomTabBarView
/// Vista personalizada del TabBar siguiendo el diseño de Figma
/// Aplicando reglas: SwiftUI, Simple solutions, Clean codebase, Debug logs & comments
struct CustomTabBarView: View {
    
    // MARK: - Properties
    let viewModel: TabBarViewModel
    
    // MARK: - Constants
    /// Dimensiones y espaciado según especificaciones de Figma
    private let tabBarHeight: CGFloat = 87
    private let horizontalPadding: CGFloat = 50
    private let tabSpacing: CGFloat = 36
    private let homeIndicatorWidth: CGFloat = 140
    private let homeIndicatorHeight: CGFloat = 5
    private let homeIndicatorBottomPadding: CGFloat = 8
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Background Overlay
            backgroundOverlay
            
            // MARK: - Tab Buttons Container
            HStack(spacing: tabSpacing) {
                ForEach(TabBarViewModel.TabItem.allCases, id: \.self) { tab in
                    TabBarItem(
                        tab: tab,
                        isSelected: viewModel.isSelected(tab),
                        action: {
                            viewModel.selectTab(tab)
                        }
                    )
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.top, 5) // Padding superior según Figma
            
            // MARK: - Home Indicator
            homeIndicator
        }
        .frame(height: tabBarHeight)
        .background(tabBarBackground)
    }
    
    // MARK: - Background Components
    /// Overlay de fondo con gradiente sutil
    private var backgroundOverlay: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.black.opacity(0.1), location: 0),
                        .init(color: Color(red: 25/255, green: 20/255, blue: 20/255).opacity(0), location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: 84)
            .offset(y: -84) // Posicionar arriba del TabBar
    }
    
    /// Fondo principal del TabBar con gradiente
    private var tabBarBackground: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color(red: 18/255, green: 18/255, blue: 18/255), location: 0.44),
                .init(color: Color.black.opacity(0.8), location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// Indicador home en la parte inferior
    private var homeIndicator: some View {
        VStack {
            Spacer()
            
            RoundedRectangle(cornerRadius: 100)
                .fill(Color.white)
                .frame(width: homeIndicatorWidth, height: homeIndicatorHeight)
                .padding(.bottom, homeIndicatorBottomPadding)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview
#Preview {
    VStack {
        Spacer()
        
        // Simular contenido de la app
        Rectangle()
            .fill(.menuBackground) // #121212
            .overlay(
                Text("Contenido de la App")
                    .foregroundColor(.white)
                    .font(.title)
            )
        
        // TabBar personalizado
        CustomTabBarView(viewModel: TabBarViewModel())
    }
    .background(.menuBackground) // #121212
    .ignoresSafeArea(.all, edges: .bottom)
}
