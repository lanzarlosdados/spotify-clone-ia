import Foundation

// MARK: - TrackRowModel
/// Presentation model for a single row in the playlist track list.
/// Keeps the domain `Track` around for the playback hand-off.
struct TrackRowModel: Identifiable, Equatable {

    let id: String
    let title: String
    let artist: String
    let coverImageName: String?
    let coverImageURL: URL?
    let isExplicit: Bool
    let track: Track

    init(from track: Track) {
        self.id = track.id
        self.title = track.title
        self.artist = track.artist
        self.coverImageName = track.coverImageName
        self.coverImageURL = track.coverImageURL
        self.isExplicit = track.isExplicit
        self.track = track
    }
}
