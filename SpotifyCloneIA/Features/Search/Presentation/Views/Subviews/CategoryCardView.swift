import SwiftUI

// MARK: - CategoryCardView
/// Horizontal card view for browse categories.
/// Used in the "Browse all" section.
struct CategoryCardView: View {
    
    // MARK: - Properties
    
    let category: SearchCategoryModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Background color
            Color(hex: category.backgroundColor)
            
            // Category title
            VStack {
                Text(category.title)
                    .font(.circular(.medium, size: 15))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                
                Spacer()
            }
            
            // Optional image placeholder (rotated for design effect)
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(25))
                .offset(x: 10, y: 10)
        }
        .frame(height: 100)
        .cornerRadius(4)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview

#Preview {
    CategoryCardView(
        category: SearchCategoryModel(
            from: SearchCategory(
                id: "1",
                title: "Music",
                backgroundColor: "#DC148C"
            )
        )
    )
    .frame(width: 180, height: 100)
    .padding()
}
