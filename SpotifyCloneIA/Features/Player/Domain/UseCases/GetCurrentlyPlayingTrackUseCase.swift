import Foundation

final class GetCurrentlyPlayingTrackUseCase {
    private let playerRepository: PlayerRepositoryProtocol

    init(playerRepository: PlayerRepositoryProtocol) {
        self.playerRepository = playerRepository
    }

    func execute() async throws -> Track {
        try await playerRepository.getCurrentlyPlayingTrack()
    }
}
