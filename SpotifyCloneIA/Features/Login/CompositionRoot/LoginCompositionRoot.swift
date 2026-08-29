import Foundation

// MARK: - LoginCompositionRoot
/// Composition Root for the Login feature.
/// Creates and wires all dependencies following the Dependency Injection pattern.
final class LoginCompositionRoot {

    // MARK: - Singleton

    static let shared = LoginCompositionRoot()

    private init() {
        // Debug log for easier debugging.
        print("🏗️ LoginCompositionRoot: Initialized.")
    }

    // MARK: - Factory Methods

    /// Creates a `LoginViewModel` with all dependencies injected.
    func makeLoginViewModel() -> LoginViewModel {
        let repository = makeRepository()
        return LoginViewModel(
            signUpFreeUseCase: SignUpFreeUseCase(repository: repository),
            authenticateWithProviderUseCase: AuthenticateWithProviderUseCase(repository: repository),
            loginWithEmailUseCase: LoginWithEmailUseCase(repository: repository)
        )
    }

    /// Creates the repository implementation.
    /// Currently returns a mock-backed repository for development.
    /// TODO: Replace the data source with real SDK integrations when ready.
    private func makeRepository() -> AuthRepositoryProtocol {
        DefaultAuthRepository(dataSource: MockAuthDataSource())
    }
}

// MARK: - Convenience Extension

extension LoginCompositionRoot {

    /// Creates a fully configured LoginView.
    func makeLoginView() -> LoginView {
        LoginView(viewModel: makeLoginViewModel())
    }
}
