import SwiftUI

// MARK: - SearchResultRowView
/// Row view displaying a single search result.
struct SearchResultRowView: View {
    
    // MARK: - Properties
    
    let result: SearchResultModel
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 12) {
            // Result image placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 56, height: 56)
                .cornerRadius(result.type == .artist ? 28 : 4)
                .overlay(
                    Image(systemName: iconForType(result.type))
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 20))
                )
            
            // Result info
            VStack(alignment: .leading, spacing: 4) {
                Text(result.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                if let subtitle = result.subtitle {
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    // MARK: - Helper Methods
    
    /// Returns the appropriate SF Symbol icon for the result type.
    private func iconForType(_ type: SearchResult.ResultType) -> String {
        switch type {
        case .track:
            return "music.note"
        case .album:
            return "square.stack"
        case .artist:
            return "person.fill"
        case .playlist:
            return "music.note.list"
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 0) {
        SearchResultRowView(
            result: SearchResultModel(
                from: SearchResult(
                    id: "1",
                    title: "Radiohead",
                    subtitle: "Artist",
                    type: .artist
                )
            )
        )
        
        SearchResultRowView(
            result: SearchResultModel(
                from: SearchResult(
                    id: "2",
                    title: "OK Computer",
                    subtitle: "Radiohead • Album",
                    type: .album
                )
            )
        )
    }
    .background(Color.black)
}
