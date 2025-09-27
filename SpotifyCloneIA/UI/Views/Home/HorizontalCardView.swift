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
    
    // Espaciado entre imagen y textos
    private let contentSpacing: CGFloat = 8
    
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
        VStack(alignment: .leading, spacing: contentSpacing) {
            Image(imageName)
                .resizable()
                .frame(width: imageSize.width, height: imageSize.height)
                .cornerRadius(4)

            // Contenedor de texto que ocupa el resto del alto disponible
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.custom("CircularStd-Medium", size: 12))
                    .foregroundColor(Color.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                if showDescription && !description.isEmpty {
                    Text(description)
                        .font(.custom("CircularStd-Book", size: 12))
                        .foregroundColor(Color.textSecondary)
                }
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(width: cardSize.width, height: cardSize.height)
    }
}


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
            
            // Caso Recently played: 94x132, sin descripción
            HorizontalCardView(
                imageName: "the-cure",
                title: "The Cure",
                description: "",
                imageSize: .init(width: 94, height: 94),
                cardSize: .init(width: 94, height: 132),
                showDescription: false
            )
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        }
    }
}
#endif
