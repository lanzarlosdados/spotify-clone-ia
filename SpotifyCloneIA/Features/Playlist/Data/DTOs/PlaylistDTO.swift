import Foundation

// MARK: - PlaylistDTO
/// Codable transport model for a playlist. Reuses `TrackDTO` (owned by `Player`).
struct PlaylistDTO: Decodable {
    let id: String
    let title: String
    let description: String
    let ownerName: String
    let coverImageName: String?
    let coverImageURL: String?
    let likesCount: Int
    let isDownloaded: Bool
    let tracks: [TrackDTO]

    enum CodingKeys: String, CodingKey {
        case id, title, description, tracks
        case ownerName = "owner_name"
        case coverImageName = "cover_image_name"
        case coverImageURL = "cover_image_url"
        case likesCount = "likes_count"
        case isDownloaded = "is_downloaded"
    }
}

extension PlaylistDTO {
    func toDomain() -> Playlist {
        Playlist(
            id: id,
            title: title,
            description: description,
            ownerName: ownerName,
            coverImageName: coverImageName,
            coverImageURL: coverImageURL.flatMap { URL(string: $0) },
            likesCount: likesCount,
            isDownloaded: isDownloaded,
            tracks: tracks.map { $0.toDomain() }
        )
    }
}
