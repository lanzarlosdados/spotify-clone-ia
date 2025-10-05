//
//  FontsManager.swift
//  SpotifyCloneIA
//
//  Created by You on 2025-10-04.
//

import SwiftUI
import CoreText

// MARK: - Familia de fuentes soportada (ampliable si en el futuro sumas otras)
enum AppFontFamily {
    case circular(CircularStd)
    
    var postScriptName: String {
        switch self {
        case .circular(let style):
            return style.postScriptName
        }
    }
}

// MARK: - Variantes de CircularStd que usaremos en la app
// Nota: Los nombres aquí deben ser los PostScript names reales de la fuente.
// En la mayoría de distribuciones son "CircularStd-Book", "CircularStd-Bold", etc.
// Para las itálicas suele ser "…Italic" SIN espacio (p. ej., "CircularStd-LightItalic")
enum CircularStd: String, CaseIterable {
    case book          = "CircularStd-Book"
    case bookItalic    = "CircularStd-BookItalic"
    case medium        = "CircularStd-Medium"
    case mediumItalic  = "CircularStd-MediumItalic"
    case bold          = "CircularStd-Bold"
    case boldItalic    = "CircularStd-BoldItalic"
    case black         = "CircularStd-Black"
    case blackItalic   = "CircularStd-BlackItalic"
    case light         = "CircularStd-Light"
    case lightItalic   = "CircularStd-LightItalic" // OJO: algunas distribuciones la muestran como “Light Italic”, pero el PostScript suele ser sin espacio.
    
    var postScriptName: String { rawValue }
}

// MARK: - Manager solo SwiftUI
enum FontsManager {
    // API base
    static func font(_ family: AppFontFamily, size: CGFloat) -> Font {
        Font.custom(family.postScriptName, size: size)
    }
    
    static func font(_ family: AppFontFamily, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font {
        Font.custom(family.postScriptName, size: size, relativeTo: textStyle)
    }
    
    // Helpers específicos para CircularStd
    static func circular(_ style: CircularStd, size: CGFloat) -> Font {
        font(.circular(style), size: size)
    }
    
    static func circular(_ style: CircularStd, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font {
        font(.circular(style), size: size, relativeTo: textStyle)
    }
}

// MARK: - Extensiones de conveniencia para uso directo
extension Font {
    // Uso: .font(.circular(.bold, size: 22))
    static func circular(_ style: CircularStd, size: CGFloat) -> Font {
        FontsManager.circular(style, size: size)
    }
    
    static func circular(_ style: CircularStd, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font {
        FontsManager.circular(style, size: size, relativeTo: textStyle)
    }
}

// MARK: - Alias de compatibilidad (opcional)
// Si en el proyecto hay usos previos como ".custom("Circular Std", ...)" puedes mapearlos aquí.
// Recomendación: migrar a .font(.circular(.book, size: ...)) en todo el código.
enum FontAliases {
    // Claves que quizá ya existan en tu código
    static let legacyCircularStdDisplay = "Circular Std" // display name usado en algunos archivos
    
    // Sugerencia de sustitución para migración rápida
    static func replacement(for legacyName: String) -> String? {
        switch legacyName {
        case legacyCircularStdDisplay:
            // El “display name” sin peso suele mapear a Book o Medium según el diseño.
            // Ajusta a tu preferencia. Aquí lo mapeamos a Book.
            return CircularStd.book.postScriptName
        default:
            return nil
        }
    }
}
