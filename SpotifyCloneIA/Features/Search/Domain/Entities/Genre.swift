import Foundation

// MARK: - Genre
/// Entity representing a musical genre in the domain layer.
/// Used for "Explore your musical type" section with hashtags.
struct Genre: Identifiable, Equatable {
    
    // MARK: - Properties
    
    let id: String
    let name: String
    let hashtag: String
    let imageURL: String?
    let backgroundColor: String
    
    // MARK: - Initialization
    
    init(
        id: String,
        name: String,
        hashtag: String,
        imageURL: String? = nil,
        backgroundColor: String
    ) {
        self.id = id
        self.name = name
        self.hashtag = hashtag
        self.imageURL = imageURL
        self.backgroundColor = backgroundColor
    }
}
