import Foundation

// MARK: - GenreDTO
/// Data Transfer Object for musical genres.
/// Used to transfer data from the data source to the domain layer.
struct GenreDTO: Codable {
    
    // MARK: - Properties
    
    let id: String
    let name: String
    let hashtag: String
    let imageURL: String?
    let backgroundColor: String
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case hashtag
        case imageURL = "image_url"
        case backgroundColor = "background_color"
    }
    
    // MARK: - Mapping
    
    /// Converts the DTO to a domain entity.
    /// - Returns: A `Genre` entity.
    func toDomain() -> Genre {
        return Genre(
            id: id,
            name: name,
            hashtag: hashtag,
            imageURL: imageURL,
            backgroundColor: backgroundColor
        )
    }
}
