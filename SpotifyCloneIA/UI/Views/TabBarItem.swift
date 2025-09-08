import SwiftUI

// MARK: - TabBarItem
/// Componente individual para cada item del TabBar
/// Aplicando reglas: SwiftUI, Simple solutions, Debug logs & comments
struct TabBarItem: View {
    
    // MARK: - Properties
    let tab: TabBarViewModel.TabItem
    let isSelected: Bool
    let action: () -> Void
    
    private let iconSize: CGFloat = 32
    private let itemWidth: CGFloat = 30
    private let spacing: CGFloat = 4
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            VStack(spacing: spacing) {
                // MARK: - Icon
                Image(iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)
                    .foregroundColor(iconColor)
                
                // MARK: - Label
                Text(tab.rawValue)
                    .font(.custom("Circular Std", size: 11))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: itemWidth)
        .buttonStyle(PlainButtonStyle())
    }
    
    private var iconName: String {
        isSelected ? tab.selectedIcon : tab.defaultIcon
    }
    
    private var iconColor: Color {
        isSelected ? .white : .subtitleText
    }
    
    private var textColor: Color {
        isSelected ? .white : .subtitleText
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        TabBarItem(
            tab: .home,
            isSelected: true,
            action: { print("🏠 Home tapped") }
        )
        
        TabBarItem(
            tab: .search,
            isSelected: false,
            action: { print("🔍 Search tapped") }
        )
        
        TabBarItem(
            tab: .library,
            isSelected: false,
            action: { print("📚 Library tapped") }
        )
    }
    .padding()
    .background(.menuBackground)
}
