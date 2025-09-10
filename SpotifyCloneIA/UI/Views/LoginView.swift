import SwiftUI

// MARK: - Login View
struct LoginView: View {
    // MARK: - Properties
    let viewModel = LoginViewModel()
    
    private let screenWidth: CGFloat = 390
    private let screenHeight: CGFloat = 844
    private let contentBottomPadding: CGFloat = 48
    private let logoPayoffGap: CGFloat = 18
    private let contentButtonsGap: CGFloat = 33
    private let buttonsHorizontalPadding: CGFloat = 32
    private let buttonSpacing: CGFloat = 12
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: contentButtonsGap) {
                        logoAndPayoffSection
                        
                        buttonsSection
                        
                        if let errorMessage = viewModel.errorMessage {
                            errorMessageView(errorMessage)
                        }
                    }
                    .padding(.bottom, contentBottomPadding)
                }
                
                if viewModel.isLoading {
                    loadingOverlay
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Logo and Payoff Section
    private var logoAndPayoffSection: some View {
        VStack(spacing: logoPayoffGap) {
            spotifyLogo
            
            payoffText
        }
    }
    
    private var spotifyLogo: some View {
        Image("spotify-logo")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.textPrimary)
            .frame(width: 44, height: 44)
    }
    
    private var payoffText: some View {
        Text("Millions of songs.\nFree on Spotify.")
            .font(.custom("Circular Std", size: 30))
            .fontWeight(.bold)
            .foregroundColor(.textPrimary)
            .multilineTextAlignment(.center)
            .lineSpacing(6)
            .frame(width: 246)
    }
    
    // MARK: - Buttons Section
    private var buttonsSection: some View {
        VStack(spacing: buttonSpacing) {
            CTAButton(
                title: "Sign up free",
                type: .primary,
                socialProvider: .none
            ) {
                handleSignUpFree()
            }
            
            CTAButton(
                title: "Continue with Google",
                type: .secondary,
                socialProvider: .google
            ) {
                handleGoogleLogin()
            }
            
            CTAButton(
                title: "Continue with Facebook",
                type: .secondary,
                socialProvider: .facebook
            ) {
                handleFacebookLogin()
            }
            
            CTAButton(
                title: "Continue with Apple",
                type: .secondary,
                socialProvider: .apple
            ) {
                handleAppleLogin()
            }
            
            CTAButton(
                title: "Log in",
                type: .secondary,
                socialProvider: .none
            ) {
                handleLogin()
            }
        }
        .padding(.horizontal, buttonsHorizontalPadding)
    }
    
    // MARK: - UI Components
    private func errorMessageView(_ message: String) -> some View {
        Text(message)
            .font(.custom("Circular Std", size: 14))
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .padding(.horizontal, buttonsHorizontalPadding)
            .padding(.top, 8)
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
                
                Text("Loading...")
                    .font(.custom("Circular Std", size: 16))
                    .foregroundColor(.white)
            }
            .padding(24)
            .background(Color.black.opacity(0.8))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Action Handlers
    private func handleSignUpFree() {
        viewModel.signUpFree()
    }
    
    private func handleGoogleLogin() {
        viewModel.authenticateWithGoogle()
    }
    
    private func handleFacebookLogin() {
        viewModel.authenticateWithFacebook()
    }
    
    private func handleAppleLogin() {
        viewModel.authenticateWithApple()
    }
    
    private func handleLogin() {
        viewModel.showLoginForm()
    }
}

// MARK: - Preview
#Preview {
    LoginView()
        .preferredColorScheme(.dark)
}
