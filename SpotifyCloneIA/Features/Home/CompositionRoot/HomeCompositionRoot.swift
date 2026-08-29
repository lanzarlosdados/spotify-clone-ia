import Foundation

// MARK: - HomeCompositionRoot
/// Composition Root for the Home feature.
/// Creates and wires all dependencies following the Dependency Injection pattern.
final class HomeCompositionRoot {

    // MARK: - Singleton

    static let shared = HomeCompositionRoot()

    private init() {
        // Debug log for easier debugging.
        print("🏗️ HomeCompositionRoot: Initialized.")
    }

    // MARK: - Factory Methods

    func makeHomeViewModel() -> HomeViewModel {
        let repository = makeRepository()
        return HomeViewModel(getHomeFeedUseCase: GetHomeFeedUseCase(repository: repository))
    }

    /// Creates the repository implementation.
    /// Currently returns a mock-backed repository for development.
    /// TODO: Replace the data source with a real (HTTPClient) one when the backend is ready.
    private func makeRepository() -> HomeRepositoryProtocol {
        DefaultHomeRepository(dataSource: MockHomeDataSource())
    }
}

// MARK: - Convenience Extension

extension HomeCompositionRoot {

    /// Creates a fully configured HomeView.
    func makeHomeView() -> HomeView {
        HomeView(viewModel: makeHomeViewModel())
    }
}
