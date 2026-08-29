import Foundation

// MARK: - AuthenticationState
/// Represents the current state of the authentication flow.
enum AuthenticationState: Equatable {
    case idle
    case loading
    case authenticated(AuthUser)
    case error(String)
}
