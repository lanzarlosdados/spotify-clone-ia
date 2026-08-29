import Foundation

// MARK: - AuthUserDTO
/// Data Transfer Object for an authenticated user.
struct AuthUserDTO: Codable {

    let id: String
    let email: String?
    let displayName: String?
    let profileImageURL: String?
    let provider: String

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case displayName = "display_name"
        case profileImageURL = "profile_image_url"
        case provider
    }

    // MARK: - Mapping

    func toDomain() -> AuthUser {
        AuthUser(
            id: id,
            email: email,
            displayName: displayName,
            profileImageURL: profileImageURL,
            provider: AuthProvider(rawValue: provider) ?? .email
        )
    }
}
