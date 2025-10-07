import Foundation

// MARK: - GenreModel
/// Presentation model for musical genres.
/// Used to display genre data in the UI.
struct GenreModel: Identifiable, Equatable {
    
    // MARK: - Properties
    
    let id: String
    let name: String
    let hashtag: String
    let imageURL: String?
    
    // MARK: - Initialization
    
    init(from entity: Genre) {
        self.id = entity.id
        self.name = entity.name
        self.hashtag = entity.hashtag
        self.imageURL = entity.imageURL
    }
}
