import Foundation

// MARK: - DefaultAuthRepository
/// Implementation of `AuthRepositoryProtocol`.
final class DefaultAuthRepository: AuthRepositoryProtocol {

    private let dataSource: AuthDataSource

    init(dataSource: AuthDataSource = MockAuthDataSource()) {
        self.dataSource = dataSource
    }

    func signUpFree() async throws {
        try await dataSource.signUpFree()
    }

    func authenticate(with provider: AuthProvider) async throws -> AuthUser {
        try await dataSource.authenticate(with: provider).toDomain()
    }

    func loginWithEmail(_ email: String, password: String) async throws -> AuthUser {
        try await dataSource.loginWithEmail(email, password: password).toDomain()
    }
}
