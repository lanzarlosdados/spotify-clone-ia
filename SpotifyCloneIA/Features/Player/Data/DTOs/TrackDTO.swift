import Foundation

struct TrackDTO: Decodable {
    let title: String
    let artist: String
    let coverImageURL: String

    enum CodingKeys: String, CodingKey {
        case title, artist
        case coverImageURL = "cover_image_url"
    }
}

extension TrackDTO {
    func toDomain() -> Track {
        return Track(title: title, artist: artist, coverImageURL: URL(string: coverImageURL))
    }
}
