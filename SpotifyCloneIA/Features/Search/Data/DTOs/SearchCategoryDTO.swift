import Foundation

// MARK: - SearchCategoryDTO
/// Data Transfer Object for search categories.
/// Used to transfer data from the data source to the domain layer.
struct SearchCategoryDTO: Codable {
    
    // MARK: - Properties
    
    let id: String
    let title: String
    let imageURL: String?
    let backgroundColor: String
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageURL = "image_url"
        case backgroundColor = "background_color"
    }
    
    // MARK: - Mapping
    
    /// Converts the DTO to a domain entity.
    /// - Returns: A `SearchCategory` entity.
    func toDomain() -> SearchCategory {
        return SearchCategory(
            id: id,
            title: title,
            imageURL: imageURL,
            backgroundColor: backgroundColor
        )
    }
}
