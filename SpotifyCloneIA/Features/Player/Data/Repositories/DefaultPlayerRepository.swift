import Foundation

final class DefaultPlayerRepository: PlayerRepositoryProtocol {
    private let dataSource: PlayerDataSource

    init(dataSource: PlayerDataSource) {
        self.dataSource = dataSource
    }

    func getCurrentlyPlayingTrack() async -> Result<Track, Error> {
        let result = await dataSource.getCurrentlyPlayingTrack()
        switch result {
        case .success(let trackDTO):
            return .success(trackDTO.toDomain())
        case .failure(let error):
            return .failure(error)
        }
    }
}
