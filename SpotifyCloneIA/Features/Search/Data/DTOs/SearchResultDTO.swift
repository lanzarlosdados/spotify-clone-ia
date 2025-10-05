import Foundation

// MARK: - SearchResultDTO
/// Data Transfer Object for search results.
/// Used to transfer data from the data source to the domain layer.
struct SearchResultDTO: Codable {
    
    // MARK: - Properties
    
    let id: String
    let title: String
    let subtitle: String?
    let imageURL: String?
    let type: String
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case imageURL = "image_url"
        case type
    }
    
    // MARK: - Mapping
    
    /// Converts the DTO to a domain entity.
    /// - Returns: A `SearchResult` entity, or nil if the type is invalid.
    func toDomain() -> SearchResult? {
        guard let resultType = SearchResult.ResultType(rawValue: type) else {
            // Debug log for easier debugging.
            print("⚠️ SearchResultDTO: Invalid result type '\(type)'")
            return nil
        }
        
        return SearchResult(
            id: id,
            title: title,
            subtitle: subtitle,
            imageURL: imageURL,
            type: resultType
        )
    }
}
