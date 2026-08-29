import Foundation

// MARK: - GetHomeFeedUseCase
/// Use case for retrieving the full Home screen feed.
final class GetHomeFeedUseCase {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> HomeFeed {
        // Debug log for easier debugging.
        print("🔍 GetHomeFeedUseCase: Fetching home feed...")
        let feed = try await repository.getHomeFeed()
        print("✅ GetHomeFeedUseCase: Home feed fetched.")
        return feed
    }
}
