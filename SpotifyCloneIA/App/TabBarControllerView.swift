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
        
        // Crear SearchViewModel usando el Composition Root del feature
        // Debug log for easier debugging.
        print("🎬 TabBarControllerView: Initializing with SearchCompositionRoot...")
        self.searchViewModel = SearchCompositionRoot.shared.makeSearchViewModel()
    }
    
    var body: some View {
        TabView(selection: $tabBarViewModel.selectedTab) {
            // Home Tab - NavigationStack for future detail navigation
            NavigationStack {
                HomeCompositionRoot.shared.makeHomeView()
            }
            .tabItem {
                TabBarItem(
                    tab: .home
                )
            }
            .tag(TabBarViewModel.TabItem.home)
            
            // Search Tab - Already has its own NavigationStack
            SearchView(viewModel: searchViewModel)
            .tabItem {
                TabBarItem(
                    tab: .search
                )
            }
            .tag(TabBarViewModel.TabItem.search)
            
            // Library Tab - NavigationStack for detail navigation
            NavigationStack {
                LibraryView()
            }
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
