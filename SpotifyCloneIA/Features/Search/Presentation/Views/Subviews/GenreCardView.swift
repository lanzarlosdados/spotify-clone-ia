import SwiftUI

// MARK: - GenreCardView
/// Card view displaying a musical genre with hashtag.
/// Used in the "Explore your musical type" section.
struct GenreCardView: View {
    
    // MARK: - Properties
    
    let genre: GenreModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background color
            Color(hex: genre.backgroundColor)
            
            // Gradient overlay
            LinearGradient(
                colors: [
                    Color.black.opacity(0.1),
                    Color.black.opacity(0.6)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Hashtag text
            Text(genre.hashtag)
                .font(.circular(.bold, size: 16))
                .foregroundColor(.white)
                .padding(12)
        }
        .frame(height: 191)
        .cornerRadius(8)
    }
}

// MARK: - Color Extension for Hex Support

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview

#Preview {
    GenreCardView(
        genre: GenreModel(
            from: Genre(
                id: "1",
                name: "Permanent Wave",
                hashtag: "#permanent wave",
                backgroundColor: "#8D67AB"
            )
        )
    )
    .frame(width: 180, height: 120)
    .padding()
}
