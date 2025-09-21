import SwiftUI
import Observation

// MARK: - TabBarControllerView
/// Vista principal del TabBarController que maneja la navegación entre tabs
/// Aplicando reglas: SwiftUI, @Observable, Simple solutions, Clean codebase, Debug logs & comments
struct TabBarControllerView: View {
    
    // MARK: - Properties
    @Bindable var tabBarViewModel: TabBarViewModel
    
    var body: some View {
        TabView(selection: $tabBarViewModel.selectedTab) {
              NavigationStack() {
                  HomeView()
                      .navigationTitle("Home")
              }
              .tabItem {
                  TabBarItem(
                      tab: .home
                  )
              }
              .tag(TabBarViewModel.TabItem.home)
              
              NavigationStack() {
                  SearchView()
                      .navigationTitle("Search")
              }
              .tabItem {
                  TabBarItem(
                      tab: .search
                  )
              }
              .tag(TabBarViewModel.TabItem.search)
              
              NavigationStack() {
                  LibraryView()
                      .navigationTitle("Your library")
                  
              }
              .tabItem {
                  TabBarItem(
                      tab: .library
                  )
              }
              .tag(TabBarViewModel.TabItem.library)
          }
        .tint(.white)
        .onAppear(perform: {
            UITabBar.appearance().unselectedItemTintColor = UIColor.unselectedTabItem
            UITabBar.appearance().backgroundColor = .black.withAlphaComponent(0.4)
        })
      }
}

// MARK: - Preview
#Preview {
    TabBarControllerView(tabBarViewModel: TabBarViewModel())
        .preferredColorScheme(.dark)
}

