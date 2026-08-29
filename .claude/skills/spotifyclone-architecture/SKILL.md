---
name: spotifyclone-architecture
description: >-
  Convenciones de estructura del proyecto SpotifyCloneIA (app iOS SwiftUI, Clean
  Architecture + MVVM organizada por feature). Usar SIEMPRE que la tarea implique
  crear, mover o ubicar archivos en este repo: nueva pantalla o feature, endpoint
  de red, entidad/DTO/modelo, caso de uso, componente de UI, color, imagen,
  fuente, datos mock, test unitario o de UI, o wiring de dependencias. Responde
  "dónde busco si ya existe" y "dónde lo creo". Detalle completo e inconsistencias
  conocidas en docs/ARCHITECTURE.md.
---

# Estructura de SpotifyCloneIA

App iOS nativa, **SwiftUI**, Swift 5.0, iOS 18.5, **sin Swift Package Manager ni
dependencias externas**. Xcode usa `PBXFileSystemSynchronizedRootGroup`: el
filesystem es la fuente de verdad — **no editar `project.pbxproj`**, basta crear
el archivo en la carpeta correcta.

Arquitectura: **Clean Architecture + MVVM, organizada por feature**, en
`SpotifyCloneIA/Features/<Feature>/`.
Feature de referencia: **`Library`** (copiar de ahí o de `Search`).
Flujo de desarrollo: **Domain → Data → Presentation → UI**.

Referencia completa: [`docs/ARCHITECTURE.md`](../../../docs/ARCHITECTURE.md).

## Anatomía de un feature — `SpotifyCloneIA/Features/<Feature>/`

| Carpeta | Contenido | Nombre |
|---|---|---|
| `Domain/Entities/` | structs planos `Identifiable`/`Equatable` | sustantivo sin sufijo (`Track`) |
| `Domain/UseCases/` | `final class`, un `execute(...) async throws`, uno por operación | `<Verbo><Sustantivo>UseCase` |
| `Domain/Repositories/` | protocolo del repo | `<Feature>RepositoryProtocol` |
| `Data/Repositories/` | impl concreta del protocolo | `Mock<Feature>Repository` / `Default<Thing>Repository` |
| `Data/DataSources/` | protocolo + mock | `<Feature>DataSource` / `Mock<Feature>DataSource` |
| `Data/DTOs/` | `Codable`, `CodingKeys` snake_case, `toDomain()` | `<Thing>DTO` |
| `Data/Mock/` | fixtures JSON (`Bundle.main.url(forResource:)`) | `Mock<Thing>.json` |
| `Presentation/ViewModels/` | `@Observable final class`, use cases por `init`, logs `print("🔄 …")` | `<Feature>ViewModel` |
| `Presentation/Models/` | modelo de presentación | `<Thing>Model` + `init(from entity:)` |
| `Presentation/Views/` | pantallas SwiftUI; sub-partes en `Components/`/`Subviews/`/`Section/` | `<Nombre>View` |
| `CompositionRoot/` | DI: singleton `.shared`, `make<X>ViewModel()`, overload `make…(with: mockRepo)` para tests | `<Feature>CompositionRoot` |

Patrón de vista: `init(viewModel: VM? = nil)` con fallback
`?? <Feature>CompositionRoot.shared.make…()`. El VM se guarda como `let`, no `@State`.

## Checklist — ¿dónde busco / dónde creo?

| Tarea | Buscar primero en… | Crear en… |
|---|---|---|
| Nueva pantalla / feature | `Features/<Feature>/` (molde: `Features/Library/`) | `Features/<Nueva>/{Domain/{Entities,UseCases,Repositories},Data/{Repositories,DataSources,DTOs,Mock},Presentation/{ViewModels,Models,Views},CompositionRoot}` + cablear en `SpotifyCloneIA/UI/Views/TabBarControllerView.swift` |
| Endpoint / llamada de red | `SpotifyCloneIA/Data/Networking/` (`Endpoint`, `HTTPMethod`, `HTTPCLient`), `SpotifyCloneIA/Infrastructure/Networking/` | DTOs en `Features/<F>/Data/DTOs/` con `toDomain()`; `Default<F>Repository` en `Features/<F>/Data/Repositories/` usando `HTTPCLient`; inyectar desde el CompositionRoot |
| Modelo de datos | `Features/<F>/Domain/Entities/`; si viene de red, `Data/DTOs/` | Entidad en `Domain/Entities/` (sin sufijo); DTO en `Data/DTOs/`; modelo UI en `Presentation/Models/` |
| Caso de uso / regla de negocio | `Features/<F>/Domain/UseCases/` | `Domain/UseCases/<Verbo><Sustantivo>UseCase.swift` (un `execute`); registrar en CompositionRoot + `init` del ViewModel |
| Componente de UI de un feature | `Features/<F>/Presentation/Views/{Components,Subviews,Section}/` | `Presentation/Views/Components/<Nombre>View.swift` |
| Componente de UI cross-feature | `SpotifyCloneIA/UI/Views/` | `SpotifyCloneIA/UI/Views/<Nombre>View.swift` |
| Color | `Assets.xcassets/resources/colors/` (subgrupos `text/`,`surface/`,`icon/`) | `.colorset` en `resources/colors/<subgrupo>/`; usar `Color("nombre")` / `Color.nombre`. NO tocar `Color+Extensions.swift` |
| Imagen / ícono de UI | `Assets.xcassets/resources/{icons,images}/` | `.imageset` en `resources/icons/` (prefijo `ico-`) o `resources/images/`; usar `Image("nombre")` |
| Imagen mock / fixture | `Assets.xcassets/mock_resources/images/` | `.imageset` en `mock_resources/images/` |
| Fuente / peso | `SpotifyCloneIA/fonts/`, enum `CircularStd` en `FontsManager.swift` | `.otf` en `fonts/` + `Info.plist` `UIAppFonts` + `case` en `CircularStd`; usar `.font(.circular(.bold, size: 22))` |
| Texto visible | Las vistas (literales en inglés; no hay String Catalog) | Literal en la vista |
| Datos mock | `Features/<F>/Data/Mock/*.json`, repos `Mock<F>…` | JSON en `Features/<F>/Data/Mock/` + `Mock<F>DataSource` que lo lee con `Bundle.main` |
| Wiring / DI | `Features/<F>/CompositionRoot/`; `TabBarControllerView` para el arranque | `make<X>ViewModel()` en `<Feature>CompositionRoot`; overload `with:` para tests |
| Test unitario | `SpotifyCloneIATests/` (hoy solo plantilla) | `SpotifyCloneIATests/Features/<F>/<Sujeto>Tests.swift`; **Swift Testing** (`import Testing`, `@Test`, `#expect`), `@testable import SpotifyCloneIA`, repo mock vía overload `with:` |
| Test de UI | `SpotifyCloneIAUITests/` | `SpotifyCloneIAUITests/<Flujo>UITests.swift`; **XCTest** + `XCUIApplication` |
| Extensión / utilidad compartida | `SpotifyCloneIA/Application/Common/Extensions/` | `Application/Common/Extensions/<Tipo>+<Qué>.swift` |
| ViewModel cross-feature | `SpotifyCloneIA/Presentation/ViewModels/` | `Presentation/ViewModels/<Nombre>ViewModel.swift` |

## Recursos — reglas rápidas

- **Fuentes**: siempre `FontsManager` → `.font(.circular(.<peso>, size: N))`. Nunca `Font.custom("...")` a mano.
- **Colores**: siempre `Assets.xcassets/resources/colors/*.colorset` → `Color("x")` / `Color.x`. `Color+Extensions.swift` está deprecado; los literales tipo `Color("#121212")` no resuelven.
- **Imágenes**: todo en `.imageset`. UI real en `resources/`, fixtures en `mock_resources/`. Los `.svg`/`.png` sueltos en el catálogo son basura que Xcode ignora — no imitarlos.
- **Localización**: no hay `.xcstrings`; strings hardcodeados.
- **Persistencia**: no hay (sin CoreData/SwiftData/Keychain).

## Convenciones de nombres

Entidades sin sufijo · `*UseCase` con `execute()` · `*RepositoryProtocol` /
`Mock*Repository` / `Default*Repository` · `*DTO` + `toDomain()` · `*Model` +
`init(from:)` · `*ViewModel` (`@Observable final class`) · `*View` ·
`*CompositionRoot` · logs `print("<emoji> <Tipo>: <msg>")`.

## Ojo con los antipatrones

`Player` y `Home` **NO** siguen la convención (VM con `ObservableObject`, carpetas
planas, `Domain/Interfaces/`, `Presentation/View/` en singular, `Home` sin capa de
datos y sin cablear en el TabBar). Ver `docs/ARCHITECTURE.md` §8. **Copiar de
`Library` o `Search`, nunca de `Player` ni `Home`.**
