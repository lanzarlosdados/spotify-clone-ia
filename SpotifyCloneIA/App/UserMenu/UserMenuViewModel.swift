//
//  UserMenuViewModel.swift
//  SpotifyCloneIA
//
//  Created by Cascade on 06/09/2025.
//

import Foundation

/// ViewModel for user menu screen following MVVM architecture
/// Handles user profile data and menu navigation logic
@Observable
final class UserMenuViewModel {
    
    // MARK: - Properties
    
    /// User's display name
    var userName: String = "Damon98"
    
    /// User's profile subtitle
    var profileSubtitle: String = "View profile"
    
    /// User's avatar image name or URL
    var avatarImageName: String = "Avatar"
    
    /// Menu items configuration
    var menuItems: [MenuItem] = []
    
    // MARK: - Initialization
    
    init() {
        setupMenuItems()
        // Debug log for easier debugging
        print("🔧 UserMenuViewModel initialized with \(menuItems.count) menu items")
    }
    
    // MARK: - Private Methods
    
    /// Configure menu items based on Figma design
    private func setupMenuItems() {
        menuItems = [
            MenuItem(
                id: "news",
                title: "What's new",
                iconName: "ico-32-news",
                action: .news
            ),
            MenuItem(
                id: "history",
                title: "Listening history", 
                iconName: "ico-32-cronology",
                action: .history
            ),
            MenuItem(
                id: "settings",
                title: "Settings and privacy",
                iconName: "ico-32-gear", 
                action: .settings
            )
        ]
        
        // Debug log for menu items setup
        print("📋 Menu items configured: \(menuItems.map { $0.title }.joined(separator: ", "))")
    }
    
    // MARK: - Public Methods
    
    /// Handle menu item selection
    /// - Parameter item: The selected menu item
    func handleMenuItemTap(_ item: MenuItem) {
        // Debug log for user interaction
        print("👆 User tapped menu item: \(item.title)")
        
        switch item.action {
        case .news:
            handleNewsNavigation()
        case .history:
            handleHistoryNavigation()
        case .settings:
            handleSettingsNavigation()
        }
    }
    
    /// Handle profile tap action
    func handleProfileTap() {
        print("👤 User tapped profile section")
        // TODO: Navigate to profile screen
    }
    
    // MARK: - Navigation Handlers
    
    private func handleNewsNavigation() {
        print("📰 Navigating to What's New screen")
        // TODO: Implement navigation to news/updates screen
    }
    
    private func handleHistoryNavigation() {
        print("🕐 Navigating to Listening History screen")
        // TODO: Implement navigation to listening history screen
    }
    
    private func handleSettingsNavigation() {
        print("⚙️ Navigating to Settings screen")
        // TODO: Implement navigation to settings screen
    }
}

// MARK: - Supporting Types

/// Menu item model for user menu
struct MenuItem: Identifiable, Equatable {
    let id: String
    let title: String
    let iconName: String
    let action: MenuAction
}

/// Available menu actions
enum MenuAction {
    case news
    case history
    case settings
}
