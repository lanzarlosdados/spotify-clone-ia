---
name: spotifyclone-architecture
description: >-
  Convenciones de estructura del proyecto SpotifyCloneIA (app iOS SwiftUI, Clean
  Architecture + MVVM organizada por feature). Usar SIEMPRE que la tarea implique
  crear, mover o ubicar archivos en este repo: nueva pantalla o feature, endpoint
  de red, entidad/DTO/modelo, caso de uso, componente de UI, color, imagen,
  fuente, datos mock, test unitario o de UI, o wiring de dependencias. Responde
  "dónde busco si ya existe" y "dónde lo creo". Detalle completo en docs/ARCHITECTURE.md.
---

# Estructura de SpotifyCloneIA

App iOS nativa, **SwiftUI**, Swift 5.0, iOS 18.5, **sin Swift Package Manager ni
dependencias externas**. Xcode usa `PBXFileSystemSynchronizedRootGroup`: el
filesystem es la fuente de verdad — **no editar `project.pbxproj`**, basta crear
el archivo en la carpeta correcta.

Arquitectura: **Clean Architecture + MVVM, por feature**, en
`SpotifyCloneIA/Features/<Feature>/`. Feature de referencia: **`Library`** o `Search`.
Flujo: Domain → Data → Presentation → UI.

Referencia completa: [`docs/ARCHITECTURE.md`](../../../docs/ARCHITECTURE.md).

## Layout de nivel superior — `SpotifyCloneIA/`

- `App/` — shell: `SpotifyCloneIAApp`, `RootView`, `SplashScreenView`, `TabBar*`, `TabBarViewModel`, `UserMenu/`.
- `Shared/` — transversal: `DesignSystem/FontsManager.swift`, `Extensions/`, `Networking/` (`HTTPClient`, `URLSessionHTTPClient`, `Endpoint`, `HTTPMethod`, ...).
- `Features/<Feature>/` — ver abajo.
- `fonts/` · `Assets.xcassets/` · `Info.plist`.
- NO recrear `Application/`, `Data/`, `Infrastructure/`, `Presentation/`, `UI/` de nivel superior.

## Anatomía de un feature — `Features/<Feature>/`

| Carpeta | Contenido | Nombre |
|---|---|---|
| `Domain/Entities/` | structs planos `Identifiable`/`Equatable` | sustantivo sin sufijo (`Track`) |
| `Domain/Repositories/` | protocolo del repo | `<Feature>RepositoryProtocol` |
| `Domain/UseCases/` | `final class`, un `execute(...) async throws` | `<Verbo><Sustantivo>UseCase` |
| `Data/DataSources/` | protocolo + mock que lee JSON con delay | `<Feature>DataSource` / `Mock<Feature>DataSource` |
| `Data/DTOs/` | `Codable`, `CodingKeys` snake_case, `toDomain()` | `<Thing>DTO` |
| `Data/Repositories/` | impl del protocolo de dominio, mapea DTO→entidad | `Default<Feature>Repository` |
| `Data/Mock/` | fixtures JSON (`Bundle.main.url(forResource:)`) | `<Nombre>.json` |
| `Presentation/ViewModels/` | `@Observable final class`, use cases por `init`, logs `print("🔄 …")` | `<Feature>ViewModel` |
| `Presentation/Models/` | modelo de presentación / mappers | `<Thing>Model` + `init(from:)` |
| `Presentation/Views/` | pantallas SwiftUI; sub-partes en `Components/`/`Subviews/`/`Section/` | `<Nombre>View` |
| `CompositionRoot/` | DI: singleton `.shared`, `make<X>ViewModel()`, overload `make…(with: mockRepo)` para tests | `<Feature>CompositionRoot` |

Patrón de vista: `init(viewModel: VM? = nil)` con fallback
`?? <Feature>CompositionRoot.shared.make…()`. El VM se guarda como `let`, no `@State`.
Carga async en `.task { await viewModel.load() }`.

## Checklist — ¿dónde busco / dónde creo?

| Tarea | Buscar primero en… | Crear en… |
|---|---|---|
| Nueva pantalla / feature | `Features/<Feature>/` (molde: `Features/Library/`) | `Features/<Nueva>/{Domain/{Entities,Repositories,UseCases},Data/{DataSources,DTOs,Repositories,Mock},Presentation/{ViewModels,Models,Views},CompositionRoot}` + cablear en `App/TabBarControllerView.swift` |
| Endpoint / red | `Shared/Networking/` (`Endpoint`, `HTTPMethod`, `HTTPClient`, `URLSessionHTTPClient`) | DTOs en `Features/<F>/Data/DTOs/` con `toDomain()`; `Default<F>Repository` vía un DataSource que consume `HTTPClient`; inyectar desde el CompositionRoot |
| Modelo de datos | `Features/<F>/Domain/Entities/`; si viene de red, `Data/DTOs/` | Entidad en `Domain/Entities/` (sin sufijo); DTO en `Data/DTOs/`; modelo UI en `Presentation/Models/` |
| Caso de uso | `Features/<F>/Domain/UseCases/` | `Domain/UseCases/<Verbo><Sustantivo>UseCase.swift` (un `execute`); registrar en CompositionRoot + `init` del ViewModel |
| Componente de UI de un feature | `Features/<F>/Presentation/Views/{Components,Subviews,Section}/` | `Presentation/Views/Components/<Nombre>View.swift` |
| Componente de UI cross-feature | `Shared/DesignSystem/` | `Shared/DesignSystem/<Nombre>View.swift` |
| Color | `Assets.xcassets/resources/colors/` (`text/`,`surface/`,`icon/`) | `.colorset` nuevo; usar `Color("x")` / `Color.x`. NUNCA `Color(red:)` ni static en Swift |
| Imagen / ícono de UI | `Assets.xcassets/resources/{icons,images}/` | `.imageset` en `resources/icons/` (prefijo `ico-`) o `resources/images/` |
| Imagen mock / fixture | `Assets.xcassets/mock_resources/images/` | `.imageset` en `mock_resources/images/` |
| Fuente / peso | `SpotifyCloneIA/fonts/`, enum `CircularStd` en `Shared/DesignSystem/FontsManager.swift` | `.otf` en `fonts/` + `Info.plist` `UIAppFonts` + `case` (rawValue = PostScript name real); usar `.font(.circular(.bold, size: 22))` |
| Texto visible | Las vistas (literales en inglés; no hay String Catalog) | Literal en la vista |
| Datos mock | `Features/<F>/Data/Mock/*.json` | JSON en `Features/<F>/Data/Mock/` + cargarlo en `Mock<F>DataSource` |
| Wiring / DI | `Features/<F>/CompositionRoot/`; `App/TabBarControllerView.swift` para el arranque | `make<X>ViewModel()` en `<Feature>CompositionRoot`; overload `with:` para tests |
| Test unitario | `SpotifyCloneIATests/` | `SpotifyCloneIATests/Features/<F>/<Sujeto>Tests.swift`; **Swift Testing**, `@testable import SpotifyCloneIA`, repo mock vía overload `with:` |
| Test de UI | `SpotifyCloneIAUITests/` | `SpotifyCloneIAUITests/<Flujo>UITests.swift`; **XCTest** + `XCUIApplication` |
| Extensión / utilidad compartida | `Shared/Extensions/` | `Shared/Extensions/<Tipo>+<Qué>.swift` |
| Código del shell (tab bar, splash, menú) | `App/` | `App/<Nombre>.swift` |

## Recursos — reglas rápidas

- **Fuentes**: siempre `FontsManager` → `.font(.circular(.<peso>, size: N))`. Nunca `Font.custom("...")` a mano.
- **Colores**: siempre `Assets.xcassets/resources/colors/*.colorset` → `Color("x")` / `Color.x`.
- **Imágenes**: todo en `.imageset`. UI real en `resources/`, fixtures en `mock_resources/`. Nada de `.svg`/`.png` sueltos en la raíz del catálogo.
- **Localización**: no hay `.xcstrings`; strings hardcodeados.
- **Persistencia**: no hay.

## Convenciones de nombres

Entidades sin sufijo · `<Verbo><Sust>UseCase` con `execute()` ·
`<Feature>RepositoryProtocol` / `Default<Feature>Repository` ·
`<Feature>DataSource` / `Mock<Feature>DataSource` · `<Thing>DTO` + `toDomain()` ·
`<Thing>Model` + `init(from:)` · `<Feature>ViewModel` (`@Observable final class`) ·
`<Nombre>View` · `<Feature>CompositionRoot` · logs `print("<emoji> <Tipo>: <msg>")`.
