import Foundation

// MARK: - LibraryItemType
/// Enum representing different types of items in the user's library.
/// Based on Figma design: Music, Podcasts, Artists, Albums, Playlists.
enum LibraryItemType: String, Codable, CaseIterable {
    case music = "Music"
    case podcast = "Podcast"
    case artist = "Artist"
    case album = "Album"
    case playlist = "Playlist"
    case likedSongs = "Liked Songs"
    
    // MARK: - Display Properties
    
    /// Icon name from Assets for each type
    var iconName: String {
        switch self {
        case .music, .likedSongs:
            return "ico-24-music"
        case .podcast:
            return "ico-24-podcast"
        case .artist:
            return "ico-24-artist"
        case .album:
            return "ico-24-album"
        case .playlist:
            return "ico-24-playlist"
        }
    }
}
