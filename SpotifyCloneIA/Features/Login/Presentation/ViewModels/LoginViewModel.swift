import Foundation

// MARK: - LoginViewModel
/// View model for the Login screen.
/// Annotated with @Observable for reactive SwiftUI views.
@Observable
final class LoginViewModel {

    // MARK: - Properties

    var authenticationState: AuthenticationState = .idle
    var isLoading: Bool = false
    var errorMessage: String?

    // MARK: - Use Cases

    private let signUpFreeUseCase: SignUpFreeUseCase
    private let authenticateWithProviderUseCase: AuthenticateWithProviderUseCase
    private let loginWithEmailUseCase: LoginWithEmailUseCase

    // MARK: - Initialization

    init(
        signUpFreeUseCase: SignUpFreeUseCase,
        authenticateWithProviderUseCase: AuthenticateWithProviderUseCase,
        loginWithEmailUseCase: LoginWithEmailUseCase
    ) {
        self.signUpFreeUseCase = signUpFreeUseCase
        self.authenticateWithProviderUseCase = authenticateWithProviderUseCase
        self.loginWithEmailUseCase = loginWithEmailUseCase

        // Debug log for easier debugging.
        print("🎯 LoginViewModel: Initialized.")
    }

    // MARK: - Public Methods

    func signUpFree() {
        run {
            try await self.signUpFreeUseCase.execute()
            await MainActor.run { self.authenticationState = .idle }
        }
    }

    func authenticateWithGoogle() { authenticate(with: .google) }
    func authenticateWithFacebook() { authenticate(with: .facebook) }
    func authenticateWithApple() { authenticate(with: .apple) }

    func showLoginForm() {
        // TODO: navigate to the email/password login screen.
        print("🔐 LoginViewModel: Navigating to login form.")
        authenticationState = .idle
    }

    func resetAuthenticationState() {
        authenticationState = .idle
        isLoading = false
        errorMessage = nil
    }

    // MARK: - Private Helpers

    private func authenticate(with provider: AuthProvider) {
        run {
            let user = try await self.authenticateWithProviderUseCase.execute(provider: provider)
            await MainActor.run { self.authenticationState = .authenticated(user) }
        }
    }

    /// Wraps an async auth operation with the shared loading / error handling.
    private func run(_ operation: @escaping () async throws -> Void) {
        Task {
            await MainActor.run {
                isLoading = true
                errorMessage = nil
                authenticationState = .loading
            }

            do {
                try await operation()
                await MainActor.run { isLoading = false }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = error.localizedDescription
                    authenticationState = .error(error.localizedDescription)
                }
                // Debug log for easier debugging.
                print("❌ LoginViewModel: \(error.localizedDescription)")
            }
        }
    }
}
