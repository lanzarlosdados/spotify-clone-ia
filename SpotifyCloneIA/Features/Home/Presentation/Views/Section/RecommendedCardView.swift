import SwiftUI

struct RecommendedCardView: View {
    let release: NewRelease

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Header
            HStack(spacing: 12) {
                Image(release.artistImageName)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text("New release from")
                        .font(.custom("CircularStd-Book", size: 12))
                        .foregroundColor(Color.textSecondary)
                    Text(release.artistName)
                        .font(.custom("CircularStd-Bold", size: 22))
                        .foregroundColor(Color.textPrimary)
                        .kerning(-0.55)
                }
                Spacer()
            }

            // MARK: - Card
            HStack(spacing: 16) {
                Image(release.artworkImageName)
                    .resizable()
                    .frame(width: 142, height: 142)

                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(release.releaseTitle)
                            .font(.custom("CircularStd-Bold", size: 12))
                            .foregroundColor(Color.textPrimary)
                        Text(release.releaseSubtitle)
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
        RecommendedCardView(release: NewRelease(
            artistName: "Arctic Monkeys",
            artistImageName: "artist_avatar",
            releaseTitle: "I Wanna Be Yours",
            releaseSubtitle: "Single • Arctic Monkeys",
            artworkImageName: "album_art"
        ))
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
#endif
