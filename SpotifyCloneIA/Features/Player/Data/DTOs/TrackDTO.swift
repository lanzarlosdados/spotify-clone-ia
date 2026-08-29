import Foundation

// MARK: - TrackDTO
/// Codable transport model for a track. Shared by `Player` and `Playlist`
/// (see `docs/ARCHITECTURE.md` §8).
struct TrackDTO: Decodable {
    let id: String?
    let title: String
    let artist: String
    let album: String?
    let coverImageURL: String?
    let coverImageName: String?
    let durationSeconds: Int?
    let isExplicit: Bool?

    enum CodingKeys: String, CodingKey {
        case id, title, artist, album
        case coverImageURL = "cover_image_url"
        case coverImageName = "cover_image_name"
        case durationSeconds = "duration_seconds"
        case isExplicit = "is_explicit"
    }
}

extension TrackDTO {
    func toDomain() -> Track {
        Track(
            id: id ?? UUID().uuidString,
            title: title,
            artist: artist,
            album: album,
            coverImageURL: coverImageURL.flatMap { URL(string: $0) },
            coverImageName: coverImageName,
            durationSeconds: durationSeconds ?? 0,
            isExplicit: isExplicit ?? false
        )
    }
}
