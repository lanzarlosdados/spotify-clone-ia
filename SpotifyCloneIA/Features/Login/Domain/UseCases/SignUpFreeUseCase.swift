import Foundation

// MARK: - SignUpFreeUseCase
/// Use case for the free sign-up flow.
final class SignUpFreeUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws {
        // Debug log for easier debugging.
        print("🔍 SignUpFreeUseCase: Starting free sign up...")
        try await repository.signUpFree()
        print("✅ SignUpFreeUseCase: Free sign up completed.")
    }
}
