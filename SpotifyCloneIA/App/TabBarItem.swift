import SwiftUI

// MARK: - TabBarItem
struct TabBarItem: View {
    
    // MARK: - Properties
    let tab: TabBarViewModel.TabItem
    
    private let iconSize: CGFloat = 32
    private let itemWidth: CGFloat = 30
    private let spacing: CGFloat = 4
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: spacing) {
            // MARK: - Icon
            Image(tab.selectedIcon)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.textPrimary)
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
            
            // MARK: - Label
            Text(tab.rawValue)
                .font(.custom("Circular Std", size: 11))
                .multilineTextAlignment(.center)
        }
        .frame(width: itemWidth)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        TabBarItem(tab: .home)
        
        TabBarItem(tab: .search)
        
        TabBarItem(tab: .library)
    }
    .padding()
    .background(.menuBackground)
}
