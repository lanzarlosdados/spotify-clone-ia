import Foundation

// MARK: - LibraryItemDTO
/// Data Transfer Object for library items from API or local storage.
/// This is the representation of data as it comes from external sources,
/// which will be mapped to domain entities.
struct LibraryItemDTO: Codable {
    
    // MARK: - Properties
    
    let id: String
    let title: String
    let description: String
    let imageURL: String?
    let type: String  // Will be mapped to LibraryItemType
    let isPinned: Bool
    let dateAdded: String  // ISO 8601 date string
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageURL = "image_url"
        case type
        case isPinned = "is_pinned"
        case dateAdded = "date_added"
    }
    
    // MARK: - Mapping to Domain Entity
    
    /// Converts DTO to domain entity LibraryItem.
    /// - Returns: LibraryItem domain entity
    func toDomain() -> LibraryItem? {
        // Parse the type string to LibraryItemType enum
        guard let itemType = LibraryItemType(rawValue: type) else {
            // Debug log for easier debugging.
            print("⚠️ LibraryItemDTO: Unknown item type: \(type)")
            return nil
        }
        
        // Parse the date string to Date
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: dateAdded) ?? Date()
        
        return LibraryItem(
            id: id,
            title: title,
            description: description,
            imageURL: imageURL,
            type: itemType,
            isPinned: isPinned,
            dateAdded: date
        )
    }
}

// MARK: - Domain Entity to DTO Mapping

extension LibraryItem {
    
    /// Converts domain entity to DTO for API requests.
    /// - Returns: LibraryItemDTO data transfer object
    func toDTO() -> LibraryItemDTO {
        let dateFormatter = ISO8601DateFormatter()
        let dateString = dateFormatter.string(from: dateAdded)
        
        return LibraryItemDTO(
            id: id,
            title: title,
            description: description,
            imageURL: imageURL,
            type: type.rawValue,
            isPinned: isPinned,
            dateAdded: dateString
        )
    }
}
