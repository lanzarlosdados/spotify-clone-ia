import SwiftUI

struct TopMixesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your top mixes")
                .font(.custom("CircularStd-Bold", size: 22))
                .foregroundColor(.white)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    TopMixesCardView(
                        imageName: "rock-mix",
                        title: "Rock Mix",
                        description: "Blur, The Killers, Kula Shaker and more"
                    )
                    TopMixesCardView(
                        imageName: "pop-mix",
                        title: "Pop Mix",
                        description: "Sabrina Carpenter, Chappell Roan, Olivia Rodrigo"
                    )
                    TopMixesCardView(
                        imageName: "upbeat-mix",
                        title: "Upbeat Mix",
                        description: "The Stokes,Chappell Roan, Talking Heads and more"
                    )
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 8)
    }
}

#if DEBUG
struct TopMixesView_Previews: PreviewProvider {
    static var previews: some View {
        TopMixesView()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
#endif
