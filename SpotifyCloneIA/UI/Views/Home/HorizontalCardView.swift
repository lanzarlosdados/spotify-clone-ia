import SwiftUI

// Vista genérica de tarjeta para el carrusel horizontal
struct HorizontalCardView: View {
    let imageName: String
    let title: String
    let description: String
    
    // Configuración dinámica
    let imageSize: CGSize
    let cardSize: CGSize
    let showDescription: Bool
    
    // Init con valores por defecto para no romper llamadas existentes
    init(
        imageName: String,
        title: String,
        description: String,
        imageSize: CGSize = .init(width: 147, height: 147),
        cardSize: CGSize = .init(width: 147, height: 206),
        showDescription: Bool = true
    ) {
        self.imageName = imageName
        self.title = title
        self.description = description
        self.imageSize = imageSize
        self.cardSize = cardSize
        self.showDescription = showDescription
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(imageName)
                .resizable()
                .frame(width: imageSize.width, height: imageSize.height)
                .cornerRadius(4)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.custom("CircularStd-Medium", size: 12))
                    .foregroundColor(Color.textPrimary)

                if showDescription && !description.isEmpty {
                    Text(description)
                        .font(.custom("CircularStd-Book", size: 12))
                        .foregroundColor(Color.textSecondary)
                }
            }
        }
        .frame(width: cardSize.width, height: cardSize.height)
    }
}

// Compatibilidad con el nombre anterior
typealias TopMixesCardView = HorizontalCardView

#if DEBUG
struct HorizontalCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Default (igual al diseño actual)
            HorizontalCardView(
                imageName: "rock-mix",
                title: "Rock Mix",
                description: "Blur, The Killers, Kula Shaker and more"
            )
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            
            // Personalizado con tamaños y ocultando descripción
            HorizontalCardView(
                imageName: "rock-mix",
                title: "Rock Mix",
                description: "Blur, The Killers, Kula Shaker and more",
                imageSize: .init(width: 160, height: 160),
                cardSize: .init(width: 160, height: 220),
                showDescription: false
            )
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        }
    }
}
#endif
