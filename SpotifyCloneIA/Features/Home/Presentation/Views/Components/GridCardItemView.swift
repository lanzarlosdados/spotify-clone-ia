import SwiftUI

struct GridCardItemView: View {
    // MARK: - Properties
    let title: String
    let imageName: String? // Optional image name
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 8) {
            // Image view
            if let imageName = imageName, let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 56, height: 56)
                    .clipped()
            } else {
                // Placeholder if no image is provided
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "music.note")
                            .foregroundColor(.white)
                    )
            }

            // Title text
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .background(Color.cardBackground)
        .cornerRadius(4)
        .frame(height: 56)
    }
}

// MARK: - Preview
#Preview {
    GridCardItemView(title: "OK Computer", imageName: nil)
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
}
