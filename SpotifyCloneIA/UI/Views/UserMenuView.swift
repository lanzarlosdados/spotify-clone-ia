//
//  UserMenuView.swift
//  SpotifyCloneIA
//
//  Created by Cascade on 06/09/2025.
//

import SwiftUI

/// User menu screen implementation based on Figma design
/// Features: Avatar, user info, menu options with proper styling
struct UserMenuView: View {
    
    // MARK: - Properties
    
    let viewModel: UserMenuViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            // Menu content
            HStack {
                menuContent
                Spacer()
            }
        }
        .background(Color("overlayBackground"))
    }
    
    // MARK: - Menu Content
    
    private var menuContent: some View {
        VStack(spacing: 16) {
            titleAndAvatar
            separator
            itemList
            Spacer()
        }
        .padding(.vertical, 60)
        .frame(width: 350)
        .background(Color("menuBackground"))
    }
    
    // MARK: - Title and Avatar Section
    
    private var titleAndAvatar: some View {
        HStack(spacing: 12) {
            // Avatar
            Button(action: {
                viewModel.handleProfileTap()
            }) {
                Image(viewModel.avatarImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            
            // Title section
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.userName)
                    .font(.custom("Circular Std", size: 19))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(viewModel.profileSubtitle)
                    .font(.custom("Circular Std", size: 12))
                    .fontWeight(.medium)
                    .foregroundColor(Color("subtitleText"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 16)
        .padding(.trailing, 24) // Additional right padding as per Figma
    }
    
    // MARK: - Separator
    
    private var separator: some View {
        Rectangle()
            .fill(Color.white.opacity(0.1))
            .frame(height: 1)
            .padding(.horizontal, 16)
    }
    
    // MARK: - Item List
    
    private var itemList: some View {
        VStack(spacing: 26) {
            ForEach(viewModel.menuItems) { item in
                menuItemRow(item)
            }
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Menu Item Row
    
    private func menuItemRow(_ item: MenuItem) -> some View {
        Button(action: {
            viewModel.handleMenuItemTap(item)
        }) {
            HStack(spacing: 8) {
                // Icon
                Image(item.iconName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                
                // Title
                Text(item.title)
                    .font(.custom("Circular Std", size: 15))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
// MARK: - Preview

#Preview {
    UserMenuView(viewModel: UserMenuViewModel())
}
