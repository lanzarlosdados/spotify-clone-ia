import Foundation

protocol PlayerRepository {
    func getCurrentlyPlayingTrack() async -> Result<Track, Error>
}
