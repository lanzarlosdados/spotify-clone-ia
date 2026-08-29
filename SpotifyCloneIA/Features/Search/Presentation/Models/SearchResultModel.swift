import Foundation

// MARK: - SearchResultModel
/// Presentation model for search results.
/// Used to display search result data in the UI.
struct SearchResultModel: Identifiable, Equatable {
    
    // MARK: - Properties
    
    let id: String
    let title: String
    let subtitle: String?
    let imageURL: String?
    let type: SearchResult.ResultType
    
    // MARK: - Initialization
    
    init(from entity: SearchResult) {
        self.id = entity.id
        self.title = entity.title
        self.subtitle = entity.subtitle
        self.imageURL = entity.imageURL
        self.type = entity.type
    }
}
