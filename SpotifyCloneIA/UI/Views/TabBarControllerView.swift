import SwiftUI

// MARK: - TabBarControllerView
/// Vista principal del TabBarController que maneja la navegación entre tabs
/// Aplicando reglas: SwiftUI, @Observable, Simple solutions, Clean codebase, Debug logs & comments
struct TabBarControllerView: View {
    
    // MARK: - Properties
    let tabBarViewModel: TabBarViewModel
    
    // MARK: - Constants
    private let screenWidth: CGFloat = 390
    private let screenHeight: CGFloat = 844
    private let contentPadding: (top: CGFloat, bottom: CGFloat) = (120, 151)
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // MARK: - Background
                backgroundColor
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    // MARK: - Content Area
                    contentView
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // MARK: - Custom TabBar
                    CustomTabBarView(viewModel: tabBarViewModel)
                }
            }
        }
        .frame(width: screenWidth, height: screenHeight)
    }
    
    // MARK: - Content Views
    /// Vista de contenido que cambia según el tab seleccionado
    @ViewBuilder
    private var contentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Spacer()
                    .frame(height: contentPadding.top)
                
                switch tabBarViewModel.selectedTab {
                case .home:
                    homeContent
                case .search:
                    searchContent
                case .library:
                    libraryContent
                }
                
                Spacer()
                    .frame(height: contentPadding.bottom)
            }
        }
    }
    
    // MARK: - Tab Content Views
    /// Contenido del tab Home
    private var homeContent: some View {
        VStack(spacing: 20) {
            Text("🏠 Home")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Bienvenido a Spotify Clone")
                .font(.title2)
                .foregroundColor(.subtitleText)
                .multilineTextAlignment(.center)
            
            // Debug info
            Text("Tab activo: \(tabBarViewModel.selectedTab.rawValue)")
                .font(.caption)
                .foregroundColor(.subtitleText)
                .padding(.top, 20)
        }
        .padding(.horizontal, 20)
    }
    
    /// Contenido del tab Search
    private var searchContent: some View {
        VStack(spacing: 20) {
            Text("🔍 Search")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Busca tu música favorita")
                .font(.title2)
                .foregroundColor(.subtitleText)
                .multilineTextAlignment(.center)
            
            // Placeholder para barra de búsqueda
            RoundedRectangle(cornerRadius: 8)
                .fill(.overlayBackground)
                .frame(height: 50)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.subtitleText)
                        Text("Buscar canciones, artistas...")
                            .foregroundColor(.subtitleText)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                )
                .padding(.horizontal, 20)
            
            // Debug info
            Text("Tab activo: \(tabBarViewModel.selectedTab.rawValue)")
                .font(.caption)
                .foregroundColor(.subtitleText)
                .padding(.top, 20)
        }
        .padding(.horizontal, 20)
    }
    
    /// Contenido del tab Library
    private var libraryContent: some View {
        VStack(spacing: 20) {
            Text("📚 Your Library")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Tu biblioteca musical")
                .font(.title2)
                .foregroundColor(.subtitleText)
                .multilineTextAlignment(.center)
            
            // Placeholder para lista de biblioteca
            VStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { index in
                    HStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.overlayBackground)
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Playlist \(index + 1)")
                                .foregroundColor(.white)
                                .font(.body)
                            Text("0 canciones")
                                .foregroundColor(.subtitleText)
                                .font(.caption)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            // Debug info
            Text("Tab activo: \(tabBarViewModel.selectedTab.rawValue)")
                .font(.caption)
                .foregroundColor(.subtitleText)
                .padding(.top, 20)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Background
    /// Color de fondo principal (#121212)
    private var backgroundColor: Color {
        Color(red: 18/255, green: 18/255, blue: 18/255)
    }
}

// MARK: - Preview
#Preview {
    TabBarControllerView(tabBarViewModel: TabBarViewModel())
        .preferredColorScheme(.dark)
}
