import Foundation

// MARK: - GetFeaturedGenresUseCase
/// Use case for fetching featured musical genres.
/// This encapsulates the business logic for retrieving the "Explore your musical type" genres.
final class GetFeaturedGenresUseCase {
    
    // MARK: - Properties
    
    private let repository: SearchRepositoryProtocol
    
    // MARK: - Initialization
    
    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    
    /// Executes the use case to fetch featured genres.
    /// - Returns: An array of `Genre` entities.
    /// - Throws: An error if the operation fails.
    func execute() async throws -> [Genre] {
        // Debug log for easier debugging.
        print("🔍 GetFeaturedGenresUseCase: Fetching featured genres...")
        
        let genres = try await repository.getFeaturedGenres()
        
        // Debug log for easier debugging.
        print("✅ GetFeaturedGenresUseCase: Fetched \(genres.count) genres.")
        
        return genres
    }
}
