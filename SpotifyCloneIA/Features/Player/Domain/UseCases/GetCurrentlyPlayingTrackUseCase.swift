import Foundation

final class GetCurrentlyPlayingTrackUseCase {
    private let playerRepository: PlayerRepository

    init(playerRepository: PlayerRepository) {
        self.playerRepository = playerRepository
    }

    func execute() async -> Result<Track, Error> {
        return await playerRepository.getCurrentlyPlayingTrack()
    }
}
