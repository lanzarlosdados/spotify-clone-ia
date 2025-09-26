import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 32) {
                
                HomeContentGridView()

                RecommendedCardView()
                
                HorizontalCardsSectionView()

                Spacer()
                    .frame(height: 151)
            }
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("#121212").ignoresSafeArea()
            HomeView()
        }
        .preferredColorScheme(.dark)
    }
}
#endif
