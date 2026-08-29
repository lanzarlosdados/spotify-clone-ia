import SwiftUI

// MARK: - CTA Button Types
enum CTAButtonType {
    case primary
    case secondary
}

// MARK: - Social Provider Types
enum SocialProvider {
    case google
    case facebook
    case apple
    case none
    
    var iconName: String {
        switch self {
        case .google:
            return "google_icon"
        case .facebook:
            return "facebook_icon"
        case .apple:
            return "apple_icon"
        case .none:
            return ""
        }
    }
}

// MARK: - CTA Button Component
struct CTAButton: View {
    let title: String
    let type: CTAButtonType
    let socialProvider: SocialProvider
    let action: () -> Void
    
    // Design specifications from Figma
    private let buttonHeight: CGFloat = 48
    private let cornerRadius: CGFloat = 25
    private let horizontalPadding: CGFloat = 40
    private let verticalPadding: CGFloat = 14
    private let iconSize: CGFloat = 24
    
    // Colors from Figma design
    private var backgroundColor: Color {
        switch type {
        case .primary:
            return Color.spotifyGreen
        case .secondary:
            return Color.clear
        }
    }
    
    private var textColor: Color {
        switch type {
        case .primary:
            return Color.black
        case .secondary:
            return Color.textPrimary
        }
    }
    
    private var borderColor: Color {
        switch type {
        case .primary:
            return Color.clear
        case .secondary:
            return Color.grayBorder
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                if socialProvider != .none {
                    socialProviderIcon
                        .frame(width: iconSize, height: iconSize)
                }
                
                Text(title)
                    .font(.circular(type == .primary ? .black : .bold, size: 14))
                    .foregroundColor(textColor)
                    .lineLimit(1)
                
                if socialProvider != .none {
                    Spacer()
                        .frame(width: iconSize)
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: .infinity)
            .frame(height: buttonHeight)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: type == .secondary ? 1 : 0)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private var socialProviderIcon: some View {
        switch socialProvider {
        case .google:
            GoogleIcon()
        case .facebook:
            FacebookIcon()
        case .apple:
            AppleIcon()
        case .none:
            EmptyView()
        }
    }
}

// MARK: - Social Provider Icons
struct GoogleIcon: View {
    var body: some View {
        Image(SocialProvider.google.iconName)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .frame(width: 24, height: 24)
    }
}

struct FacebookIcon: View {
    var body: some View {
        Image(SocialProvider.facebook.iconName)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .frame(width: 24, height: 24)
    }
}

struct AppleIcon: View {
    var body: some View {
        Image(SocialProvider.apple.iconName)
            .renderingMode(.template)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.textPrimary)
            .frame(width: 24, height: 24)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 12) {
        CTAButton(
            title: "Sign up free",
            type: .primary,
            socialProvider: .none
        ) {
            print("Sign up tapped")
        }
        
        CTAButton(
            title: "Continue with Google",
            type: .secondary,
            socialProvider: .google
        ) {
            print("Google tapped")
        }
        
        CTAButton(
            title: "Continue with Facebook",
            type: .secondary,
            socialProvider: .facebook
        ) {
            print("Facebook tapped")
        }
        
        CTAButton(
            title: "Continue with Apple",
            type: .secondary,
            socialProvider: .apple
        ) {
            print("Apple tapped")
        }
        
        CTAButton(
            title: "Log in",
            type: .secondary,
            socialProvider: .none
        ) {
            print("Log in tapped")
        }
    }
    .padding(32)
    .background(Color.backgroundApp)
}
