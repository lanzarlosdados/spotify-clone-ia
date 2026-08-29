import Foundation

// MARK: - AuthenticateWithProviderUseCase
/// Use case for authenticating with a social provider (Google, Facebook, Apple).
final class AuthenticateWithProviderUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(provider: AuthProvider) async throws -> AuthUser {
        // Debug log for easier debugging.
        print("🔍 AuthenticateWithProviderUseCase: Authenticating with \(provider.rawValue)...")
        let user = try await repository.authenticate(with: provider)
        print("✅ AuthenticateWithProviderUseCase: Authenticated as \(user.displayName ?? user.id).")
        return user
    }
}
