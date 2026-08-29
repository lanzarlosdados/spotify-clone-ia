import Foundation

// MARK: - DefaultHomeRepository
/// Implementation of `HomeRepositoryProtocol`.
final class DefaultHomeRepository: HomeRepositoryProtocol {

    private let dataSource: HomeDataSource

    init(dataSource: HomeDataSource = MockHomeDataSource()) {
        self.dataSource = dataSource
    }

    func getHomeFeed() async throws -> HomeFeed {
        try await dataSource.fetchHomeFeed().toDomain()
    }
}
