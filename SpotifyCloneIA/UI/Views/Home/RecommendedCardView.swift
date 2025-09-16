import SwiftUI

struct RecommendedCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Header
            HStack(spacing: 12) {
                Image("artist_avatar")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("New release from")
                        .font(.custom("CircularStd-Book", size: 12))
                        .foregroundColor(Color(hex: "#B3B3B3"))
                    Text("Arctic Monkeys")
                        .font(.custom("CircularStd-Bold", size: 22))
                        .foregroundColor(.white)
                        .kerning(-0.55)
                }
                Spacer()
            }
            
            // MARK: - Card
            HStack(spacing: 16) {
                // MARK: - TODO
                // Set a fixed width for the card to prevent it from expanding horizontally.
                // The Spacer inside the nested VStack was causing the layout to stretch.
                // A width of 320 provides a balanced and visually appealing size.

                Image("album_art")
                    .resizable()
                    .frame(width: 142, height: 142)
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("I Wanna Be Yours")
                            .font(.custom("CircularStd-Bold", size: 12))
                            .foregroundColor(.white)
                        Text("Single • Arctic Monkeys")
                            .font(.custom("CircularStd-Book", size: 12))
                            .foregroundColor(Color(hex: "#DEDEDE"))
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image("plus_circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        Spacer()
                        
                        Button(action: {
                            // Play action
                        }) {
                            Image("play_icon")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 15, height: 15)
                                .foregroundColor(Color(hex: "#121212"))
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.trailing, 16)
                .padding(.vertical, 16)
            }
            .frame(height: 142)
            .background(Color(hex: "#292929"))
            .cornerRadius(8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

// MARK: - Preview
#if DEBUG
struct RecommendedCardView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendedCardView()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
#endif

// Extension to allow using hex colors
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
            blue: Double(b) / 255, 
            opacity: Double(a) / 255
        )
    }
}
