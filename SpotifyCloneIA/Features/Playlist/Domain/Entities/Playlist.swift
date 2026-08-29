import Foundation

// MARK: - Playlist
/// A playlist and its ordered track list. `Track` is the canonical entity owned by
/// the `Player` feature (see `docs/ARCHITECTURE.md` §8).
struct Playlist: Identifiable, Equatable {

    let id: String
    let title: String
    let description: String
    let ownerName: String
    let coverImageName: String?
    let coverImageURL: URL?
    let likesCount: Int
    let isDownloaded: Bool
    let tracks: [Track]

    var totalDurationSeconds: Int {
        tracks.reduce(0) { $0 + $1.durationSeconds }
    }
}
