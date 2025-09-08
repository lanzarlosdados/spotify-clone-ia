import Foundation

// MARK: - TabBarViewModel
/// ViewModel para manejar el estado del TabBar principal
/// Aplicando reglas: @Observable, Simple solutions, Clean codebase
@Observable
final class TabBarViewModel {
    
    // MARK: - Properties
    /// Tab actualmente seleccionado
    var selectedTab: TabItem = .home
    
    // MARK: - Tab Items
    /// Enum que define los tabs disponibles
    enum TabItem: String, CaseIterable {
        case home = "Home"
        case search = "Search" 
        case library = "Your library"
        
        // MARK: - Icon Names
        /// Nombre del ícono para el estado seleccionado
        var selectedIcon: String {
            switch self {
            case .home:
                return "ico-32-home-fill"
            case .search:
                return "ico-32-search"
            case .library:
                return "ico-32-library"
            }
        }
        
        /// Nombre del ícono para el estado default
        var defaultIcon: String {
            switch self {
            case .home:
                return "ico-32-home-fill" // Mismo ícono filled para home
            case .search:
                return "ico-32-search"
            case .library:
                return "ico-32-library"
            }
        }
        
        // MARK: - Tab Index
        /// Índice del tab para navegación
        var index: Int {
            switch self {
            case .home: return 0
            case .search: return 1
            case .library: return 2
            }
        }
    }
    
    // MARK: - Methods
    /// Selecciona un tab específico
    /// - Parameter tab: Tab a seleccionar
    func selectTab(_ tab: TabItem) {
        selectedTab = tab
        // Debug log para facilitar debugging
        print("🔄 TabBar: Seleccionado tab \(tab.rawValue)")
    }
    
    /// Verifica si un tab está seleccionado
    /// - Parameter tab: Tab a verificar
    /// - Returns: true si está seleccionado
    func isSelected(_ tab: TabItem) -> Bool {
        return selectedTab == tab
    }
}
