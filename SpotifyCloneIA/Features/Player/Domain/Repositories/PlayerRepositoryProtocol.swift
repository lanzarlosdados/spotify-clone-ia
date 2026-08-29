import Foundation

protocol PlayerRepositoryProtocol {
    func getCurrentlyPlayingTrack() async throws -> Track
}
