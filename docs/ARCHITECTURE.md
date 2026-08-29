# Arquitectura y convenciones — SpotifyCloneIA

> Referencia para saber **dónde buscar un recurso existente** y **dónde crear uno
> nuevo**. Derivado del código real. Feature de referencia: **`Library`**
> (o `Search`) — todas las features siguen el mismo molde.

---

## 1. TL;DR / stack

| Aspecto | Valor |
|---|---|
| Plataforma | iOS nativo, **SwiftUI** (`@main struct App`) |
| Lenguaje / target | Swift 5.0, `IPHONEOS_DEPLOYMENT_TARGET = 18.5`, Xcode 16.x |
| Dependencias | **Ninguna.** Sin SPM, sin CocoaPods. Capa de red propia (`Shared/Networking/`). |
| Arquitectura | **Clean Architecture + MVVM, por feature** |
| Proyecto Xcode | `PBXFileSystemSynchronizedRootGroup`: el filesystem manda — **no hay que editar `project.pbxproj`** para agregar/mover archivos. |
| ViewModels | `@Observable final class`, use cases inyectados por `init` |
| Datos | Todo mockeado: `Default<Feature>Repository` → `Mock<Feature>DataSource` → JSON en `Features/<F>/Data/Mock/` |
| Persistencia | Ninguna (sin CoreData / SwiftData / Realm / Keychain) |
| Localización | No hay String Catalog: strings en inglés en las vistas |

### Targets

| Target | Carpeta | Framework de test |
|---|---|---|
| `SpotifyCloneIA` | `SpotifyCloneIA/` | — |
| `SpotifyCloneIATests` | `SpotifyCloneIATests/` | **Swift Testing** (`import Testing`, `@Test`) — usa `@testable import SpotifyCloneIA` |
| `SpotifyCloneIAUITests` | `SpotifyCloneIAUITests/` | **XCTest** (`XCUIApplication`) |

---

## 2. Mapa de carpetas

```
SpotifyCloneIA/
├── App/                              # shell de la app
│   ├── SpotifyCloneIAApp.swift       # @main → SplashScreenView
│   ├── RootView.swift                # → TabBarControllerView
│   ├── SplashScreenView.swift
│   ├── TabBarControllerView.swift    # wiring de los 3 tabs
│   ├── TabBarItem.swift
│   ├── TabBarViewModel.swift
│   └── UserMenu/{UserMenuView, UserMenuViewModel}.swift
│
├── Shared/                           # código transversal
│   ├── DesignSystem/FontsManager.swift
│   ├── Extensions/
│   └── Networking/                   # Endpoint, HTTPClient, HTTPMethod,
│                                     #   URLSessionHTTPClient, RequestMaker, ErrorResolver
│
├── Features/<Feature>/               # Home · Library · Login · Player · Search
│   ├── Domain/{Entities, Repositories, UseCases}
│   ├── Data/{DataSources, DTOs, Repositories, Mock/*.json}
│   ├── Presentation/{ViewModels, Models, Views/{Components|Subviews|Section}}
│   └── CompositionRoot/<Feature>CompositionRoot.swift
│
├── fonts/                            # 10 .otf CircularStd (alta en Info.plist)
└── Assets.xcassets/
    ├── resources/{colors, icons, images}   # assets reales de UI (.colorset / .imageset)
    └── mock_resources/images               # fixtures visuales
```

### Cadena de arranque

```
SpotifyCloneIAApp → SplashScreenView → RootView → TabBarControllerView
                                                    ├── Home    → HomeCompositionRoot.shared.makeHomeView()
                                                    ├── Search  → SearchCompositionRoot.shared.makeSearchViewModel()
                                                    └── Library → LibraryView() → LibraryCompositionRoot.shared
```

> El Player todavía no tiene un "now playing" real: se abre con un botón temporal
> en el header de Home (`fullScreenCover` → `PlayerCompositionRoot.shared.makePlayerView()`).

---

## 3. Anatomía de un feature

| Carpeta | Qué contiene | Convención | Ejemplo |
|---|---|---|---|
| `Domain/Entities/` | structs planos, `Identifiable`/`Equatable`, sin lógica | sustantivo **sin sufijo** | `Track`, `LibraryItem` |
| `Domain/Repositories/` | **protocolo** del repositorio | `<Feature>RepositoryProtocol` | `SearchRepositoryProtocol` |
| `Domain/UseCases/` | `final class`, un `execute(...) async throws`, uno por operación | `<Verbo><Sustantivo>UseCase` | `SearchContentUseCase` |
| `Data/DataSources/` | protocolo `<Feature>DataSource` + `Mock<Feature>DataSource` (lee JSON, aplica delay simulado) | `<Feature>DataSource` | `SearchDataSource` / `MockSearchDataSource` |
| `Data/DTOs/` | `Codable`; `CodingKeys` en `snake_case`; método `toDomain()` | `<Thing>DTO` | `TrackDTO`, `LibraryItemDTO` |
| `Data/Repositories/` | impl del protocolo de dominio; delega en el DataSource y mapea DTO→entidad | `Default<Feature>Repository` | `DefaultSearchRepository` |
| `Data/Mock/` | fixtures JSON (leídas con `Bundle.main.url(forResource:)`) | `<Nombre>.json` | `SearchCategories.json`, `HomeFeed.json` |
| `Presentation/ViewModels/` | `@Observable final class`; use cases por `init`; logs `print("🔄 …")` | `<Feature>ViewModel` | `SearchViewModel` |
| `Presentation/Models/` | modelo de presentación / mappers a tipos de vista | `<Thing>Model` + `init(from entity:)` | `SearchCategoryModel` |
| `Presentation/Views/` | pantallas SwiftUI; sub-partes en `Components/` · `Subviews/` · `Section/` | `<Nombre>View` | `SearchView`, `GenreCardView` |
| `CompositionRoot/` | DI del feature: singleton `.shared`, `make<X>ViewModel()` / `make<X>View()`; overload `make…(with: mockRepo)` para tests | `<Feature>CompositionRoot` | `LibraryCompositionRoot` |

### Patrón ViewModel + View

```swift
@Observable
final class SearchViewModel {
    private let searchContentUseCase: SearchContentUseCase
    init(searchContentUseCase: SearchContentUseCase) { … }
    func load() async { await MainActor.run { … }; do { … } catch { … } }
}

struct LibraryView: View {
    let viewModel: LibraryViewModel            // `let`, no @State
    init(viewModel: LibraryViewModel? = nil) {
        self.viewModel = viewModel ?? LibraryCompositionRoot.shared.makeLibraryViewModel()
    }
    var body: some View { … .task { await viewModel.load() } }
}
```

### Logs

`print("<emoji> <Tipo>: <mensaje>")` — `🔄` en curso, `✅` éxito, `❌` error,
`⚠️` advertencia, `🏗️` composition roots, `🎯` init de ViewModel.

---

## 4. Checklist — ¿dónde busco / dónde creo?

| Tarea | Buscar primero en… | Crear en… |
|---|---|---|
| **Nueva pantalla / feature** | `Features/<Feature>/` (molde: `Features/Library/`) | `Features/<Nueva>/{Domain/{Entities,Repositories,UseCases}, Data/{DataSources,DTOs,Repositories,Mock}, Presentation/{ViewModels,Models,Views}, CompositionRoot}` + cablear en [App/TabBarControllerView.swift](../SpotifyCloneIA/App/TabBarControllerView.swift) |
| **Endpoint / llamada de red** | [Shared/Networking/](../SpotifyCloneIA/Shared/Networking/) (`Endpoint`, `HTTPMethod`, `HTTPClient`, `URLSessionHTTPClient`) | DTOs en `Features/<F>/Data/DTOs/` con `toDomain()`; `Default<F>Repository` usa un DataSource que consume `HTTPClient`; inyectar desde el CompositionRoot |
| **Modelo de datos** | `Features/<F>/Domain/Entities/`; si viene de red, `Data/DTOs/` | Entidad en `Domain/Entities/` (sin sufijo); DTO en `Data/DTOs/`; modelo de UI en `Presentation/Models/` |
| **Caso de uso / regla de negocio** | `Features/<F>/Domain/UseCases/` | `Domain/UseCases/<Verbo><Sustantivo>UseCase.swift` (un `execute`); registrarlo en el CompositionRoot y el `init` del ViewModel |
| **Componente de UI de un feature** | `Features/<F>/Presentation/Views/{Components,Subviews,Section}/` | `Presentation/Views/Components/<Nombre>View.swift` |
| **Componente de UI cross-feature** | `Shared/DesignSystem/` | `Shared/DesignSystem/<Nombre>View.swift` |
| **Color** | `Assets.xcassets/resources/colors/` (`text/`, `surface/`, `icon/`) | `.colorset` en `resources/colors/`; usar `Color("nombre")` / `Color.nombre`. Nunca `Color(red:…)` ni un static en Swift |
| **Imagen / ícono de UI** | `Assets.xcassets/resources/{icons,images}/` | `.imageset` en `resources/icons/` (prefijo `ico-`) o `resources/images/` |
| **Imagen mock / fixture** | `Assets.xcassets/mock_resources/images/` | `.imageset` en `mock_resources/images/` |
| **Fuente / peso** | `SpotifyCloneIA/fonts/`, enum `CircularStd` en [FontsManager.swift](../SpotifyCloneIA/Shared/DesignSystem/FontsManager.swift) | `.otf` en `fonts/` + `Info.plist` `UIAppFonts` + `case` en `CircularStd` (rawValue = PostScript name real). Usar `.font(.circular(.bold, size: 22))` |
| **Texto visible** | Las vistas (literales en inglés; no hay String Catalog) | Literal en la vista |
| **Datos mock** | `Features/<F>/Data/Mock/*.json` | JSON en `Features/<F>/Data/Mock/` + cargarlo en `Mock<F>DataSource` con `Bundle.main` |
| **Wiring / DI** | `Features/<F>/CompositionRoot/`; `App/TabBarControllerView.swift` para el arranque | `make<X>ViewModel()` en `<Feature>CompositionRoot`; overload `with:` para tests |
| **Test unitario** | `SpotifyCloneIATests/` | `SpotifyCloneIATests/Features/<F>/<Sujeto>Tests.swift`; **Swift Testing**, `@testable import SpotifyCloneIA`, repo mock vía el overload `with:` del CompositionRoot |
| **Test de UI** | `SpotifyCloneIAUITests/` | `SpotifyCloneIAUITests/<Flujo>UITests.swift`; **XCTest** + `XCUIApplication` |
| **Extensión / utilidad compartida** | `Shared/Extensions/` | `Shared/Extensions/<Tipo>+<Qué>.swift` |
| **Código del shell (tab bar, splash, menú)** | `App/` | `App/<Nombre>.swift` |

---

## 5. Convenciones de nombres

Entidades sin sufijo · `<Verbo><Sust>UseCase` con `execute()` ·
`<Feature>RepositoryProtocol` / `Default<Feature>Repository` ·
`<Feature>DataSource` / `Mock<Feature>DataSource` · `<Thing>DTO` + `toDomain()` ·
`<Thing>Model` + `init(from:)` · `<Feature>ViewModel` (`@Observable final class`) ·
`<Nombre>View` · `<Feature>CompositionRoot` (singleton `.shared`).

---

## 6. Recursos

- **Fuentes**: siempre `FontsManager` → `.font(.circular(.<peso>, size: N))`.
  Archivos en `fonts/`, alta en `Info.plist` → `UIAppFonts` (los 10 `.otf`).
  Nota: los pesos Light usan la familia PostScript `CircularSpotifyText`, el resto `CircularStd`.
- **Colores**: `Assets.xcassets/resources/colors/*.colorset` → símbolos generados
  (`ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES`).
- **Imágenes**: todo en `.imageset`. UI real en `resources/`, fixtures en `mock_resources/`.
- **Localización**: no hay `.xcstrings`; strings hardcodeados en inglés.
- **Persistencia**: no hay.

---

## 7. Dependency Injection

- No hay contenedor global. Cada feature tiene su `<Feature>CompositionRoot`
  (singleton `.shared`) en `Features/<F>/CompositionRoot/`.
- `make<X>ViewModel()` arma repo → use cases → ViewModel.
- Seam de tests: overload `make…(with: <Feature>RepositoryProtocol)`.
- El arranque (`App/TabBarControllerView.swift`) conecta el CompositionRoot de cada tab.

---

## 8. Historial

Este repo fue alineado a esta convención en la rama `SCI-refactor-arquitectura`
(un commit por área: test targets, `Shared/`+`App/`, fuentes, colores, assets,
y luego Player / Search / Library / Login / Home). Antes de eso, `Player` y `Home`
divergían del patrón y había colores/fuentes/assets fuera del asset catalog — ver
`git log` de esa rama para el detalle.

**Pendiente / aceptado como excepción:**
- `App/UserMenu/` es una pantalla con ViewModel pero sin capa Domain/Data (es un overlay puro).
- El asset `darkText` colisiona con el símbolo `UIColor.darkText` (warning del compilador) — renombrar si molesta.
- No hay tests reales todavía (solo las plantillas).
- **Bug preexistente** en `LibraryViewModel.applyFiltersAndSort()`: reconstruye
  `LibraryItem` sin `dateAdded`, así que el orden "Recents" nunca ordena de verdad
  (muestra los items en orden ~arbitrario). No se tocó en el refactor para no
  cambiar comportamiento; para arreglarlo hay que llevar `dateAdded` hasta
  `LibraryItemModel`.
- Los `#Preview` de las section views de Home usan `.previewLayout` (warning:
  ignorado dentro de `#Preview`) — preexistente.
