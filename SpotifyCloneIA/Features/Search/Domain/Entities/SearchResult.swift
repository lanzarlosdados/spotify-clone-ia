import Foundation

// MARK: - SearchResult
/// Entity representing a search result that can be a track, album, artist, or playlist.
struct SearchResult: Identifiable, Equatable {
    
    // MARK: - ResultType
    
    enum ResultType: String, Codable {
        case track
        case album
        case artist
        case playlist
    }
    
    // MARK: - Properties
    
    let id: String
    let title: String
    let subtitle: String?
    let imageURL: String?
    let type: ResultType
    
    // MARK: - Initialization
    
    init(
        id: String,
        title: String,
        subtitle: String? = nil,
        imageURL: String? = nil,
        type: ResultType
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.type = type
    }
}
