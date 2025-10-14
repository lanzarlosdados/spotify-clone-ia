import SwiftUI

// MARK: - LibraryThumbView
/// ⚠️ DEPRECADO: Este componente ya no se usa en LibraryView.
/// LibraryView ahora utiliza HorizontalCardView (de Home feature) para mantener consistencia.
/// 
/// Card view displaying a library item with image, title, description and optional pin.
/// Originalmente usado en grid de 2 columnas, ahora reemplazado por HorizontalCardView en grid de 3 columnas.
@available(*, deprecated, message: "Use HorizontalCardView instead for better consistency across the app")
struct LibraryThumbView: View {
    
    // MARK: - Properties
    
    let item: LibraryItemModel
    
    // MARK: - Layout Constants
    
    private let imageSize: CGFloat = 64
    private let spacing: CGFloat = 8
    private let pinSize: CGFloat = 12
    
    // MARK: - Body
    
    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            // Thumbnail image
            AsyncImage(url: URL(string: item.imageName)) { phase in
                switch phase {
                case .empty:
                    // Loading placeholder
                    placeholderView
                case .success(let image):
                    // Successfully loaded image
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imageSize, height: imageSize)
                        .cornerRadius(4)
                case .failure:
                    // Failed to load, show placeholder
                    placeholderView
                @unknown default:
                    placeholderView
                }
            }
            .frame(width: imageSize, height: imageSize)
            
            // Text content
            VStack(alignment: .leading, spacing: 2) {
                // Title with optional pin icon
                HStack(spacing: 4) {
                    if item.showPin {
                        Image("ico-12-pin")
                            .resizable()
                            .frame(width: pinSize, height: pinSize)
                            .foregroundColor(Color.spotifyGreen)
                    }
                    
                    Text(item.title)
                        .font(.custom("CircularStd-Book", size: 14))
                        .foregroundColor(Color.textPrimary)
                        .lineLimit(1)
                }
                
                // Description (type + metadata)
                Text(item.description)
                    .font(.custom("CircularStd-Book", size: 12))
                    .foregroundColor(Color.textSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Helper Views
    
    /// Placeholder view when image is loading or failed
    private var placeholderView: some View {
        Rectangle()
            .fill(Color.cardBackground)
            .frame(width: imageSize, height: imageSize)
            .cornerRadius(4)
            .overlay(
                Image(systemName: item.type.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.textSecondary)
            )
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.primaryBackground.ignoresSafeArea()
        
        VStack(spacing: 16) {
            // Example with pin
            LibraryThumbView(
                item: LibraryItemModel(
                    from: LibraryItem(
                        id: "1",
                        title: "Liked Songs",
                        description: "Playlist • 16 songs",
                        type: .likedSongs,
                        isPinned: true
                    )
                )
            )
            .padding(.horizontal)
            
            // Example without pin
            LibraryThumbView(
                item: LibraryItemModel(
                    from: LibraryItem(
                        id: "2",
                        title: "Your Episodes",
                        description: "Podcast • 4 episodes",
                        type: .podcast,
                        isPinned: false
                    )
                )
            )
            .padding(.horizontal)
        }
    }
    .preferredColorScheme(.dark)
}
