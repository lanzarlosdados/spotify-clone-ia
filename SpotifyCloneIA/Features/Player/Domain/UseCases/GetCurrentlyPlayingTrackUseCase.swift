import Foundation

final class GetCurrentlyPlayingTrackUseCase {
    private let playerRepository: PlayerRepositoryProtocol

    init(playerRepository: PlayerRepositoryProtocol) {
        self.playerRepository = playerRepository
    }

    func execute() async -> Result<Track, Error> {
        return await playerRepository.getCurrentlyPlayingTrack()
    }
}
