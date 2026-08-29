import Foundation

protocol PlayerDataSource {
    func getCurrentlyPlayingTrack() async -> Result<TrackDTO, Error>
}

class MockPlayerDataSource: PlayerDataSource {
    func getCurrentlyPlayingTrack() async -> Result<TrackDTO, Error> {
        guard let url = Bundle.main.url(forResource: "MockTrack", withExtension: "json") else {
            return .failure(NSError(domain: "MockPlayerDataSource", code: 404, userInfo: [NSLocalizedDescriptionKey: "MockTrack.json not found."]))
        }

        do {
            let data = try Data(contentsOf: url)
            let trackDTO = try JSONDecoder().decode(TrackDTO.self, from: data)
            return .success(trackDTO)
        } catch {
            return .failure(error)
        }
    }
}
