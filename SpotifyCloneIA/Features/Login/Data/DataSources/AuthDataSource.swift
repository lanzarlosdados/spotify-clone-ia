import Foundation

// MARK: - AuthDataSource
/// Contract for the Login feature's raw authentication access.
protocol AuthDataSource {
    func signUpFree() async throws
    func authenticate(with provider: AuthProvider) async throws -> AuthUserDTO
    func loginWithEmail(_ email: String, password: String) async throws -> AuthUserDTO
}

// MARK: - AuthError

enum AuthError: LocalizedError {
    case providerFailed(String)

    var errorDescription: String? {
        switch self {
        case .providerFailed(let provider):
            return "Failed to authenticate with \(provider). Please try again."
        }
    }
}

// MARK: - MockAuthDataSource
/// Simulated authentication for development: random success/failure after a delay.
/// TODO: replace with real SDK integrations (Google/Facebook/Apple, email backend).
final class MockAuthDataSource: AuthDataSource {

    func signUpFree() async throws {
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5s
    }

    func authenticate(with provider: AuthProvider) async throws -> AuthUserDTO {
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2s

        guard Bool.random() else {
            throw AuthError.providerFailed(provider.rawValue.capitalized)
        }

        return AuthUserDTO(
            id: UUID().uuidString,
            email: "user@\(provider.rawValue).com",
            displayName: "Spotify User",
            profileImageURL: nil,
            provider: provider.rawValue
        )
    }

    func loginWithEmail(_ email: String, password: String) async throws -> AuthUserDTO {
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2s

        guard Bool.random() else {
            throw AuthError.providerFailed("email")
        }

        return AuthUserDTO(
            id: UUID().uuidString,
            email: email,
            displayName: nil,
            profileImageURL: nil,
            provider: AuthProvider.email.rawValue
        )
    }
}
