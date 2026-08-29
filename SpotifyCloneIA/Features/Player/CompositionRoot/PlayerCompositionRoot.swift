import Foundation
import SwiftUI

final class PlayerCompositionRoot {
    @MainActor
    static func createPlayerView() -> some View {
        let dataSource = MockPlayerDataSource()
        let repository = DefaultPlayerRepository(dataSource: dataSource)
        let useCase = GetCurrentlyPlayingTrackUseCase(playerRepository: repository)
        let viewModel = PlayerViewModel(getCurrentlyPlayingTrackUseCase: useCase)
        return PlayerView(viewModel: viewModel)
    }
}
