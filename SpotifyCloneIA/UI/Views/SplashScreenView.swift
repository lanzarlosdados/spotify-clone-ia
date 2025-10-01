//
//  FigmaSplashScreenView.swift
//  SpotifyCloneIA
//
//  Created by fabian zarate on 05/09/2025.

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0
    
    private let splashDuration: Double = 2.5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.backgroundApp)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    Spacer()
                        .frame(height: 313)
                    
                    SpotifyLogoView()
                        .frame(width: 140, height: 140)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) {

                withAnimation(.easeInOut(duration: 0.5)) {
                    isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            ContentView()
        }
    }
}

// MARK: - Spotify Logo Component
struct SpotifyLogoView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.clear)
                .frame(width: 140, height: 140)
            
            if let logoImage = UIImage(named: "spotify-logo") {
                Image(uiImage: logoImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 140, height: 140)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SplashScreenView()
        .preferredColorScheme(.dark) // Preview-only to test Dark Mode
}
