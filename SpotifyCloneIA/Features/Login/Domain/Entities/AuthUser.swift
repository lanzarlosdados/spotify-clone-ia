import Foundation

// MARK: - AuthUser
/// Entity representing an authenticated user in the domain layer.
struct AuthUser: Equatable {
    let id: String
    let email: String?
    let displayName: String?
    let profileImageURL: String?
    let provider: AuthProvider
}

// MARK: - AuthProvider

enum AuthProvider: String, Codable {
    case email
    case google
    case facebook
    case apple
}
