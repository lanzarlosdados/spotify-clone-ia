import Foundation
import SwiftUI

@MainActor
final class PlayerViewModel: ObservableObject {
    @Published var track: Track?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let getCurrentlyPlayingTrackUseCase: GetCurrentlyPlayingTrackUseCase

    init(getCurrentlyPlayingTrackUseCase: GetCurrentlyPlayingTrackUseCase) {
        self.getCurrentlyPlayingTrackUseCase = getCurrentlyPlayingTrackUseCase
    }

    func fetchTrack() {
        isLoading = true
        errorMessage = nil

        Task {
            let result = await getCurrentlyPlayingTrackUseCase.execute()
            switch result {
            case .success(let track):
                self.track = track
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
