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
                        .foregroundColor(Color.textSecondary)
                    Text("Arctic Monkeys")
                        .font(.custom("CircularStd-Bold", size: 22))
                        .foregroundColor(Color.textPrimary)
                        .kerning(-0.55)
                }
                Spacer()
            }
            
            // MARK: - Card
            HStack(spacing: 16) {
                // MARK: - TODO

                Image("album_art")
                    .resizable()
                    .frame(width: 142, height: 142)
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("I Wanna Be Yours")
                            .font(.custom("CircularStd-Bold", size: 12))
                            .foregroundColor(Color.textPrimary)
                        Text("Single • Arctic Monkeys")
                            .font(.custom("CircularStd-Book", size: 12))
                            .foregroundColor(Color.textTertiary)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image("plus_circle")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.iconPrimary)
                            .clipShape(Circle())
                        Spacer()
                        
                        Button(action: {
                            // Play action
                        }) {
                            Image("play_icon")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.trailing, 16)
                .padding(.vertical, 16)
            }
            .frame(height: 142)
            .background(Color.surfaceSecondary)
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
