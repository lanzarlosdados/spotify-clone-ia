import Foundation

// MARK: - SearchCategoryModel
/// Presentation model for search categories.
/// Used to display category data in the UI.
struct SearchCategoryModel: Identifiable, Equatable {
    
    // MARK: - Properties
    
    let id: String
    let title: String
    let imageURL: String?
    let backgroundColor: String
    
    // MARK: - Initialization
    
    init(from entity: SearchCategory) {
        self.id = entity.id
        self.title = entity.title
        self.imageURL = entity.imageURL
        self.backgroundColor = entity.backgroundColor
    }
}
