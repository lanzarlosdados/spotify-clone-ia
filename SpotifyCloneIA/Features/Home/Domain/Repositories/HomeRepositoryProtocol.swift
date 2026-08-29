import Foundation

// MARK: - HomeRepositoryProtocol
/// Contract for fetching the Home screen feed.
protocol HomeRepositoryProtocol {
    func getHomeFeed() async throws -> HomeFeed
}
