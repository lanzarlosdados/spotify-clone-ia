import Foundation

// MARK: - LoginWithEmailUseCase
/// Use case for logging in with email and password.
final class LoginWithEmailUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(email: String, password: String) async throws -> AuthUser {
        // Debug log for easier debugging.
        print("🔍 LoginWithEmailUseCase: Logging in \(email)...")
        let user = try await repository.loginWithEmail(email, password: password)
        print("✅ LoginWithEmailUseCase: Logged in as \(user.email ?? user.id).")
        return user
    }
}
