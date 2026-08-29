import Foundation

// MARK: - AuthRepositoryProtocol
/// Contract for authentication operations.
protocol AuthRepositoryProtocol {
    /// Starts the free sign-up flow.
    func signUpFree() async throws

    /// Authenticates the user with a social provider.
    func authenticate(with provider: AuthProvider) async throws -> AuthUser

    /// Logs in with email and password.
    func loginWithEmail(_ email: String, password: String) async throws -> AuthUser
}
