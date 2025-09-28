import SwiftUI

// MARK: - HomeHeaderView
/// A container view that assembles the main components of the Home screen's header.
/// This view follows our clean architecture principles by delegating responsibilities to specialized sub-views.
struct HomeHeaderView: View {
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            // Top navigation bar with user avatar and controls.
            HomeNavigationView()
            
        }
    }
}

// MARK: - Preview
#Preview {
    VStack {
        HomeHeaderView()
        Spacer()
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
