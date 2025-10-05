import Foundation

// MARK: - SearchCategory
/// Entity representing a search category in the domain layer.
/// Categories like Music, Podcasts, Live Events, etc.
struct SearchCategory: Identifiable, Equatable {
    
    // MARK: - Properties
    
    let id: String
    let title: String
    let imageURL: String?
    let backgroundColor: String
    
    // MARK: - Initialization
    
    init(
        id: String,
        title: String,
        imageURL: String? = nil,
        backgroundColor: String
    ) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.backgroundColor = backgroundColor
    }
}
