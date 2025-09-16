import SwiftUI

// MARK: - HomeNavigationView
/// Componente de la barra de navegación superior de la pantalla Home.
/// Aplicando reglas: SwiftUI, Simple solutions, Clean codebase, Debug logs & comments
struct HomeNavigationView: View {
    
    // MARK: - Properties
    @State private var showNotifications = false
    @State private var showUserMenu = false
    
    // MARK: - Constants
    private let headerHeight: CGFloat = 60
    private let avatarSize: CGFloat = 40
    private let notificationIconSize: CGFloat = 24
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 16) {
            // MARK: - User Avatar
            userAvatarButton
            
            Spacer()
            
            // MARK: - Premium Badge (Optional)
            premiumBadge
            
            // MARK: - Notification Button
            notificationButton
        }
        .padding(.horizontal, 16)
        .frame(height: headerHeight)
        .background(headerBackground)
    }
    
    // MARK: - User Avatar Button
    /// Avatar del usuario (circular, 40x40px)
    private var userAvatarButton: some View {
        Button(action: {
            showUserMenu.toggle()
            print("🎯 HomeNavigationView: User avatar tapped - showing menu: \(showUserMenu)")
        }) {
            ZStack {
                // Avatar background
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 29/255, green: 185/255, blue: 84/255),
                                Color(red: 30/255, green: 215/255, blue: 96/255)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: avatarSize, height: avatarSize)
                
                // Avatar image or initials
                if let avatarImage = loadAvatarImage() {
                    Image(uiImage: avatarImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: avatarSize, height: avatarSize)
                        .clipShape(Circle())
                } else {
                    // Fallback to initials
                    Text("FZ")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
        .sheet(isPresented: $showUserMenu) {
            UserMenuView(viewModel: UserMenuViewModel())
        }
    }
    
    // MARK: - Premium Badge
    /// Indicador Premium (opcional)
    private var premiumBadge: some View {
        Group {
            if shouldShowPremiumBadge() {
                HStack(spacing: 4) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.yellow)
                    
                    Text("Premium")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Capsule()
                                .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
    }
    
    // MARK: - Notification Button
    /// Botón de notificaciones
    private var notificationButton: some View {
        Button(action: {
            showNotifications.toggle()
            print("🔔 HomeNavigationView: Notification button tapped - showing: \(showNotifications)")
        }) {
            ZStack {
                // Base icon
                Image(systemName: "bell")
                    .font(.system(size: notificationIconSize, weight: .medium))
                    .foregroundColor(.white)
                
                // Notification badge
                if hasUnreadNotifications() {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: 8, y: -8)
                }
            }
        }
        .frame(width: 44, height: 44) // Larger tap area
        .sheet(isPresented: $showNotifications) {
            notificationsView
        }
    }
    
    // MARK: - Header Background
    /// Fondo del header con gradiente sutil
    private var headerBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.black.opacity(0.8),
                Color.black.opacity(0.6)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: - Notifications View
    /// Vista de notificaciones (placeholder)
    private var notificationsView: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("🔔 Notificaciones")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("No tienes notificaciones nuevas")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Notificaciones")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        showNotifications = false
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Carga la imagen del avatar del usuario
    private func loadAvatarImage() -> UIImage? {
        if let image = UIImage(named: "Avatar") {
            print("✅ HomeNavigationView: Avatar image loaded from Assets")
            return image
        }
        print("⚠️ HomeNavigationView: Avatar image not found, using fallback")
        return nil
    }
    
    /// Determina si debe mostrar el badge Premium
    private func shouldShowPremiumBadge() -> Bool {
        return false
    }
    
    /// Verifica si hay notificaciones no leídas
    private func hasUnreadNotifications() -> Bool {
        return true
    }
}

// MARK: - Preview
#Preview {
    HomeNavigationView()
        .background(Color.black)
        .preferredColorScheme(.dark)
}
