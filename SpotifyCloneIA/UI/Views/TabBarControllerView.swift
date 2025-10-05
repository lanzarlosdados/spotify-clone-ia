import SwiftUI
import Observation

// MARK: - TabBarControllerView
/// Vista principal del TabBarController que maneja la navegación entre tabs
/// Aplicando reglas: SwiftUI, @Observable, Simple solutions, Clean codebase, Debug logs & comments
struct TabBarControllerView: View {
    
    // MARK: - Properties
    @Bindable var tabBarViewModel: TabBarViewModel
    
    // Mantener una única instancia del ViewModel de búsqueda usando la factory
    private let searchViewModel: SearchViewModel
    
    // MARK: - Init
    init(tabBarViewModel: TabBarViewModel) {
        self.tabBarViewModel = tabBarViewModel
        
        // Crear SearchViewModel usando la factory (Composition Root pattern)
        // Debug log for easier debugging.
        print("🎬 TabBarControllerView: Initializing with SearchFactory...")
        self.searchViewModel = SearchFactory.shared.makeSearchViewModel()
    }
    
    var body: some View {
        TabView(selection: $tabBarViewModel.selectedTab) {
            HomeView()
            .tabItem {
                TabBarItem(
                    tab: .home
                )
            }
            .tag(TabBarViewModel.TabItem.home)
            
            SearchView(viewModel: searchViewModel)
            .tabItem {
                TabBarItem(
                    tab: .search
                )
            }
            .tag(TabBarViewModel.TabItem.search)
            
            LibraryView()
            .tabItem {
                TabBarItem(
                    tab: .library
                )
            }
            .tag(TabBarViewModel.TabItem.library)
        }
        .tint(Color.textPrimary)
    }
}

// MARK: - Preview
#Preview {
    TabBarControllerView(tabBarViewModel: TabBarViewModel())
        .preferredColorScheme(.light)
}
