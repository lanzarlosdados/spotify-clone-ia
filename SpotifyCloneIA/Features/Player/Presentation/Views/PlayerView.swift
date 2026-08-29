import SwiftUI

struct PlayerView: View {

    // Using `let` for the @Observable view model as per state management rules.
    let viewModel: PlayerViewModel

    init(viewModel: PlayerViewModel? = nil) {
        self.viewModel = viewModel ?? PlayerCompositionRoot.shared.makePlayerViewModel()
    }

    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView()
            } else if let track = viewModel.track {
                VStack {
                    AsyncImage(url: track.coverImageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                            .padding()
                    } placeholder: {
                        Image("today-two")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                            .padding()
                    }

                    Text(track.title)
                        .font(.title)
                        .foregroundColor(.white)

                    Text(track.artist)
                        .font(.title2)
                        .foregroundColor(.gray)

                    // Progress Bar Placeholder
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(.gray)
                        .padding()

                    // Player Controls
                    HStack(spacing: 40) {
                        Image("shuffle")
                            .resizable()
                            .frame(width: 32, height: 32)
                        Image("backward")
                            .resizable()
                            .frame(width: 32, height: 32)
                        Image(systemName: "play.fill") // Placeholder
                            .resizable()
                            .frame(width: 48, height: 48)
                        Image("forward")
                            .resizable()
                            .frame(width: 32, height: 32)
                        Image("repeat")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()

                    Spacer()
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    PlayerView()
}
