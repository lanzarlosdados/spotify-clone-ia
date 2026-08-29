import Foundation

protocol PlayerRepositoryProtocol {
    func getCurrentlyPlayingTrack() async -> Result<Track, Error>
}
