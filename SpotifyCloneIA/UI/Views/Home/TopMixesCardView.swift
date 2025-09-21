import SwiftUI

struct TopMixesCardView: View {
    let imageName: String
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(imageName)
                .resizable()
                .frame(width: 147, height: 147)
                .cornerRadius(4)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.custom("CircularStd-Medium", size: 12))
                    .foregroundColor(Color.textPrimary)

                Text(description)
                    .font(.custom("CircularStd-Book", size: 12))
                    .foregroundColor(Color.textSecondary)
            }
        }
        .frame(width: 147,height: 206)
    }
}

#if DEBUG
struct TopMixesCardView_Previews: PreviewProvider {
    static var previews: some View {
        TopMixesCardView(
            imageName: "rock-mix",
            title: "Rock Mix",
            description: "Blur, The Killers, Kula Shaker and more"
        )
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
#endif
