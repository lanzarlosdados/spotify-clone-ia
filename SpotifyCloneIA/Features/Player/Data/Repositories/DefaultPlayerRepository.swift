import Foundation

final class DefaultPlayerRepository: PlayerRepositoryProtocol {
    private let dataSource: PlayerDataSource

    init(dataSource: PlayerDataSource) {
        self.dataSource = dataSource
    }

    func getCurrentlyPlayingTrack() async throws -> Track {
        let dto = try await dataSource.getCurrentlyPlayingTrack()
        return dto.toDomain()
    }
}
