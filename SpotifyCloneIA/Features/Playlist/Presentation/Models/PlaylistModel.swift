import Foundation

// MARK: - PlaylistModel
/// Presentation model for the Playlist screen. Maps `Playlist` → view-ready strings.
struct PlaylistModel: Identifiable, Equatable {

    let id: String
    let title: String
    let description: String
    let ownerName: String
    let coverImageName: String?
    let coverImageURL: URL?
    /// e.g. "191,165 likes · 3h 45min".
    let metaText: String
    let tracks: [TrackRowModel]

    init(from playlist: Playlist) {
        self.id = playlist.id
        self.title = playlist.title
        self.description = playlist.description
        self.ownerName = playlist.ownerName
        self.coverImageName = playlist.coverImageName
        self.coverImageURL = playlist.coverImageURL
        self.tracks = playlist.tracks.map(TrackRowModel.init(from:))

        let likes = Self.likesFormatter.string(from: NSNumber(value: playlist.likesCount))
            ?? "\(playlist.likesCount)"
        self.metaText = "\(likes) likes · \(Self.durationText(playlist.totalDurationSeconds))"
    }

    // MARK: - Formatting

    private static let likesFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    /// "3h 45min" / "45min".
    static func durationText(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return hours > 0 ? "\(hours)h \(minutes)min" : "\(minutes)min"
    }
}
