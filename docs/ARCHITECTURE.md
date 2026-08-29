# Arquitectura y convenciones — SpotifyCloneIA

> Documento de referencia para saber **dónde buscar un recurso existente** y
> **dónde crear uno nuevo** en este proyecto. Derivado del código real (agosto 2026),
> no de suposiciones. Complementa `.windsurf/rules/localrules.md` y
> [TECHNOLOGY_ANALYSIS.md](../TECHNOLOGY_ANALYSIS.md).

---

## 1. TL;DR / stack

| Aspecto | Valor |
|---|---|
| Plataforma | iOS nativo, **SwiftUI** (`@main struct App`), sin UIKit salvo ajustes puntuales de `UINavigationBarAppearance` |
| Lenguaje / target | Swift 5.0, `IPHONEOS_DEPLOYMENT_TARGET = 18.5`, Xcode 16.4 |
| Dependencias | **Ninguna.** Sin Swift Package Manager, sin CocoaPods, sin Carthage. Capa de red propia. |
| Arquitectura | **Clean Architecture + MVVM, organizada por feature** |
| Proyecto Xcode | Un solo `SpotifyCloneIA.xcodeproj`. **`PBXFileSystemSynchronizedRootGroup`**: el filesystem es la fuente de verdad — **no hay que editar `project.pbxproj` para agregar/mover archivos**, basta crearlos en la carpeta correcta. |
| Persistencia | Ninguna (sin CoreData / SwiftData / Realm / Keychain). Estado en memoria. |
| Localización | Flags de String Catalog activos pero **no hay `.xcstrings`**: strings hardcodeados en inglés en las vistas. |
| Feature de referencia | **`Library`** — es el molde a seguir para features nuevas. |

### Targets

| Target | Carpeta | Framework de test | Estado |
|---|---|---|---|
| `SpotifyCloneIA` | `SpotifyCloneIA/` | — | app |
| `SpotifyCloneIATests` | `SpotifyCloneIATests/` | **Swift Testing** (`import Testing`, `@Test`) | solo plantilla vacía |
| `SpotifyCloneIAUITests` | `SpotifyCloneIAUITests/` | **XCTest** (`XCUIApplication`) | solo plantilla vacía |

---

## 2. Mapa de carpetas

```
SpotifyCloneIA/
├── SpotifyCloneIAApp.swift        # @main → SplashScreenView
├── ContentView.swift              # → TabBarControllerView (raíz real de la app)
├── Info.plist                     # solo UIAppFonts
│
├── Features/                      # ← todo feature nuevo va acá
│   ├── Home/                      #   (parcial: solo Presentation; ver §8)
│   ├── Library/                   #   ★ referencia canónica del patrón
│   ├── Login/                     #   (parcial: solo Presentation; ver §8)
│   ├── Player/                    #   (diverge del patrón; ver §8)
│   └── Search/                    #   (completo, similar a Library)
│
├── Application/Common/Extensions/ # Color+Extensions, FontsManager
├── Data/Networking/               # contratos: Endpoint, HTTPCLient, HTTPMethod, HTTPClientError
├── Infrastructure/Networking/     # impl URLSession: URLSessionHTTPCLient, RequestMaker, ErrorResolver
├── Presentation/ViewModels/       # ViewModels cross-feature: TabBarViewModel, UserMenuViewModel
├── UI/Views/                      # vistas cross-feature: SplashScreenView, TabBarControllerView, TabBarItem, UserMenuView
├── fonts/                         # 10 .otf CircularStd
└── Assets.xcassets/               # ver §6
```

### Cadena de arranque

```
SpotifyCloneIAApp  →  SplashScreenView  →  ContentView  →  TabBarControllerView
                                                              ├── tab Home    → PlayerCompositionRoot.createPlayerView()   ⚠️ (debería ser HomeView)
                                                              ├── tab Search  → SearchView(SearchFactory.shared.make…)
                                                              └── tab Library → LibraryView()  → LibraryCompositionRoot.shared
```

---

## 3. Anatomía de un feature

Cada feature vive en `SpotifyCloneIA/Features/<Feature>/` y se divide en capas Clean.
**Flujo de desarrollo: Domain → Data → Presentation → UI.**

| Carpeta | Qué contiene | Convención | Ejemplo |
|---|---|---|---|
| `Domain/Entities/` | structs planos, `Identifiable` / `Equatable`, sin lógica | sustantivo **sin sufijo** | `Track`, `LibraryItem`, `SearchCategory` |
| `Domain/UseCases/` | `final class`, un método `execute(...) async throws`, **un use case por operación** | verbo + sustantivo + `UseCase` | `SearchContentUseCase`, `ToggleLibraryItemPinUseCase` |
| `Domain/Repositories/` | **protocolo** del repositorio | `<Feature>RepositoryProtocol` | `SearchRepositoryProtocol`, `LibraryRepositoryProtocol` |
| `Data/Repositories/` | implementación concreta del protocolo | `Mock<Feature>Repository` (mock) · `Default<Thing>Repository` (real) | `MockLibraryRepository`, `DefaultPlayerRepository` |
| `Data/DataSources/` | protocolo `<Feature>DataSource` + `Mock<Feature>DataSource` | `<Feature>DataSource` | `PlayerDataSource` / `MockPlayerDataSource` |
| `Data/DTOs/` | `Codable`; `CodingKeys` en `snake_case`; método `toDomain()` | `<Thing>DTO` | `TrackDTO`, `SearchCategoryDTO` |
| `Data/Mock/` | fixtures JSON (leídas con `Bundle.main.url(forResource:)`) | `Mock<Thing>.json` | `MockTrack.json` |
| `Presentation/ViewModels/` | `@Observable final class`; use cases inyectados por `init`; logs `print("🔄 …")` | `<Feature>ViewModel` / `<Componente>ViewModel` | `SearchViewModel`, `CardSlimViewModel` |
| `Presentation/Models/` | modelo de presentación mapeado desde la entidad | `<Thing>Model` + `init(from entity:)` | `SearchCategoryModel`, `LibraryItemModel` |
| `Presentation/Views/` | pantallas SwiftUI; sub-partes en `Components/` · `Subviews/` · `Section/` | `<Nombre>View` | `SearchView`, `GenreCardView` |
| `CompositionRoot/` | DI del feature: `singleton .shared` con `make<X>ViewModel()` / `make<X>View()`; overload `make…(with: mockRepo)` para tests | `<Feature>CompositionRoot` | `LibraryCompositionRoot` |

### El patrón ViewModel + View

```swift
// ViewModel: @Observable, use cases por init, sin lógica de red directa
@Observable
final class SearchViewModel {
    private let searchContentUseCase: SearchContentUseCase
    init(searchContentUseCase: SearchContentUseCase) { … }
}

// View: recibe el VM (let, no @State); fallback al CompositionRoot
struct LibraryView: View {
    let viewModel: LibraryViewModel
    init(viewModel: LibraryViewModel? = nil) {
        self.viewModel = viewModel ?? LibraryCompositionRoot.shared.makeLibraryViewModel()
    }
}
```

### Convención de logs

`print("<emoji> <Tipo>: <mensaje>")` — `🔄` en curso, `✅` éxito, `❌` error,
`⚠️` advertencia, `🏭`/`🏗️` factories, `🎯` init de ViewModel, `📌` acción.

---

## 4. Checklist — ¿dónde busco / dónde creo?

| Tarea | Buscar primero en… | Crear en… |
|---|---|---|
| **Nueva pantalla / feature** | `Features/<Feature>/` — ¿ya existe algo parecido? Molde: `Features/Library/` | `Features/<NuevaFeature>/{Domain/{Entities,UseCases,Repositories}, Data/{Repositories,DataSources,DTOs,Mock}, Presentation/{ViewModels,Models,Views}, CompositionRoot}` + cablear en [TabBarControllerView.swift](../SpotifyCloneIA/UI/Views/TabBarControllerView.swift) o en la navegación del feature padre |
| **Nuevo endpoint / llamada de red** | `Data/Networking/` (`Endpoint`, `HTTPMethod`, `HTTPCLient`) y `Infrastructure/Networking/` (`URLSessionHTTPCLient`) | DTOs en `Features/<F>/Data/DTOs/` con `toDomain()`; el repo concreto (`Default<F>Repository`) en `Features/<F>/Data/Repositories/` consumiendo `HTTPCLient`; inyectarlo desde el CompositionRoot |
| **Nuevo modelo de datos** | `Features/<F>/Domain/Entities/`; si viene de red, `Data/DTOs/` | Entidad en `Domain/Entities/` (sin sufijo); DTO en `Data/DTOs/` (`<X>DTO` + `toDomain()`); modelo de UI en `Presentation/Models/` (`<X>Model` + `init(from:)`) |
| **Nuevo caso de uso / regla de negocio** | `Features/<F>/Domain/UseCases/` | `Domain/UseCases/<Verbo><Sustantivo>UseCase.swift` con un `execute(...)`; registrarlo en el CompositionRoot y pasarlo al ViewModel por `init` |
| **Componente de UI reutilizable (de un feature)** | `Features/<F>/Presentation/Views/{Components,Subviews,Section}/` — `Home` y `Search` tienen varios | `Presentation/Views/Components/<Nombre>View.swift` |
| **Componente de UI cross-feature / design system** | `UI/Views/` (hoy) | `UI/Views/<Nombre>View.swift` (a futuro: `Shared/DesignSystem/`) |
| **Nuevo color** | `Assets.xcassets/resources/colors/` (subgrupos `text/`, `surface/`, `icon/`) — ¿ya hay un `.colorset`? | `.colorset` nuevo en `resources/colors/<subgrupo>/`. Consumir con `Color("nombre")` / símbolo generado `Color.nombre`. **No** agregar statics a `Color+Extensions.swift` |
| **Nueva imagen / ícono de UI** | `Assets.xcassets/resources/{icons,images}/` | `.imageset` en `resources/icons/` (íconos `ico-…`) o `resources/images/`. Consumir con `Image("nombre")` |
| **Imagen de mock / fixture visual** | `Assets.xcassets/mock_resources/images/` | `.imageset` en `mock_resources/images/` |
| **Nueva fuente / peso tipográfico** | `SpotifyCloneIA/fonts/` y el enum `CircularStd` en [FontsManager.swift](../SpotifyCloneIA/Application/Common/Extensions/FontsManager.swift) | `.otf` en `fonts/` + entrada en `Info.plist` → `UIAppFonts` + `case` en `CircularStd`. Consumir con `.font(.circular(.bold, size: 22))` |
| **Texto visible al usuario** | Las vistas — hoy son literales en inglés | Literal en la vista (no hay i18n). Si se introduce: `Localizable.xcstrings` en la raíz del target `SpotifyCloneIA/` |
| **Datos mock para desarrollo** | `Features/<F>/Data/Mock/*.json` y repos `Mock<F>Repository` | JSON en `Features/<F>/Data/Mock/` + `Mock<F>DataSource` que lo lee con `Bundle.main` (patrón de `Player`) |
| **Wiring / inyección de dependencias** | `Features/<F>/CompositionRoot/`; `TabBarControllerView` para el arranque | Método `make<X>ViewModel()` en el `<Feature>CompositionRoot`; overload `make…(with: repo)` para tests |
| **Test unitario** | `SpotifyCloneIATests/` (hoy solo la plantilla) | `SpotifyCloneIATests/Features/<F>/<Sujeto>Tests.swift` — Swift Testing (`import Testing`, `@Test`, `#expect`), `@testable import SpotifyCloneIA`, inyectar repo mock vía el overload `with:` del CompositionRoot |
| **Test de UI** | `SpotifyCloneIAUITests/` | `SpotifyCloneIAUITests/<Flujo>UITests.swift` — XCTest + `XCUIApplication` |
| **Extensión / utilidad compartida** | `Application/Common/Extensions/` | `Application/Common/Extensions/<Tipo>+<Qué>.swift` (a futuro: `Shared/Extensions/`) |
| **ViewModel cross-feature (tab bar, menú de usuario…)** | `Presentation/ViewModels/` | `Presentation/ViewModels/<Nombre>ViewModel.swift` |

---

## 5. Convenciones de nombres

- **Carpetas**: PascalCase. Primero por feature, luego por capa Clean.
- **Entidades de dominio**: sustantivo, sin sufijo — `Track`, `Genre`, `LibraryItem`.
- **Use cases**: `<Verbo><Sustantivo>UseCase`, con un único `execute(...)`.
- **Protocolo de repo**: `<Feature>RepositoryProtocol` (preferido) — `Player` usa `<Thing>Repository` en `Domain/Interfaces/` (excepción, ver §8).
- **Impl de repo**: `Mock<Feature>Repository` (mock) · `Default<Thing>Repository` (real) · evitar `<Feature>Repository` a secas para un mock (lo hace `Search`, ver §8).
- **Data source**: protocolo `<Feature>DataSource` + `Mock<Feature>DataSource`.
- **DTO**: `<Thing>DTO`, `Codable`, `CodingKeys` en `snake_case`, método `toDomain()`.
- **Modelo de presentación**: `<Thing>Model` + `init(from entity:)`.
- **ViewModel**: `<Feature>ViewModel` / `<Componente>ViewModel`, `@Observable final class`.
- **Vistas**: `<Nombre>View`. Pantallas en `Presentation/Views/`; sub-partes en `Components/` / `Subviews/` / `Section/`.
- **Composition root**: `<Feature>CompositionRoot` (unificar; `SearchFactory` es la excepción).
- **Headers de archivo**: inconsistentes en el repo (algunos con el bloque Xcode, otros no; autores "fabian zarate" / "Fabian Zarate" / "You" / "Cascade"). Para archivos nuevos: header mínimo o ninguno, de forma consistente.

---

## 6. Recursos

### Fuentes
- Todo consumo de fuente pasa por `FontsManager` → `.font(.circular(.<peso>, size: N))`.
- Archivos `.otf` en `SpotifyCloneIA/fonts/`; alta en `Info.plist` → `UIAppFonts`.
- ⚠️ `Info.plist` lista **8 de 10** `.otf`: faltan `CircularStd-Black.otf` y
  `CircularStd-BookItalic.otf`, por lo que `CircularStd.black` y `.bookItalic`
  **no cargan** en runtime (ver §8 #9).

### Colores
- Fuente única: `Assets.xcassets/resources/colors/` — `.colorset` agrupados en
  `icon/`, `surface/`, `text/`. Con `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES`
  se generan símbolos: `Color.spotifyGreen`, `Color("backgroundApp")`, `Color.textPrimary`.
- ⚠️ Coexiste `Application/Common/Extensions/Color+Extensions.swift` con statics
  hardcodeados (`.primaryBackground`, `.cardBackground`) y hay literales como
  `Color("#121212")`. **No ampliar** ese archivo; migrar a `.colorset` (ver §8 #7).

### Imágenes
- **UI real**: `Assets.xcassets/resources/{icons,images}/` en `.imageset`. Íconos con prefijo `ico-` / `ico-32-` / `ico-24-`.
- **Fixtures / mock**: `Assets.xcassets/mock_resources/images/` en `.imageset`.
- ⚠️ Hay `.svg` / `.png` **sueltos** en la raíz de `Assets.xcassets/` y en
  `mock_resources/` sin envoltorio `.imageset` — Xcode los ignora. No agregar así (ver §8 #8).

### Localización
- No hay String Catalog (`.xcstrings`) ni `.strings`. `developmentRegion = en`,
  `knownRegions = (en, Base)`. Los textos son literales en las vistas.

### Persistencia
- No hay. `MockLibraryRepository` mantiene un `var items` en memoria.

---

## 7. Dependency Injection / composición

- **No hay contenedor global.** Cada feature expone su propio Composition Root /
  Factory en `Features/<F>/CompositionRoot/`.
- Dos estilos hoy:
  - Singleton con estado: `LibraryCompositionRoot.shared` / `SearchFactory.shared`
    → `make<X>ViewModel()` / `make<X>View()`.
  - Estático sin estado: `PlayerCompositionRoot.createPlayerView()`.
- **Preferir** el singleton `<Feature>CompositionRoot` con métodos `make…`.
- **Seam de tests**: overload que acepta un repo mock, p. ej.
  `SearchFactory.makeSearchViewModel(with: SearchRepositoryProtocol)`.
- El arranque (`TabBarControllerView`) es quien conecta los composition roots de
  cada tab.

---

## 8. Inconsistencias conocidas + plan de migración

> Ninguna bloquea el trabajo diario, pero conviene no propagarlas. **Para código
> nuevo, copiar de `Library` o `Search`, no de `Player` ni `Home`.**

| # | Inconsistencia | Migración propuesta | Riesgo / esfuerzo |
|---|---|---|---|
| 1 | **`Player` diverge del patrón**: protocolo en `Domain/Interfaces/` (no `Domain/Repositories/`); archivos sueltos en `Data/` sin subcarpetas; `Presentation/PlayerViewModel.swift` sin `ViewModels/`; usa `ObservableObject`/`@Published` (no `@Observable`); `PlayerCompositionRoot` estático sin `.shared`; vistas en `UI/` | Mover `PlayerRepository.swift` → `Domain/Repositories/`; `Data/*.swift` → `Data/{Repositories,DTOs,DataSources}/`; `PlayerViewModel.swift` → `Presentation/ViewModels/` y migrar a `@Observable`; `PlayerView` → `Presentation/Views/`; `PlayerCompositionRoot` al patrón singleton | medio |
| 2 | **`UI/` vs `Presentation/Views/`** para vistas de feature: `localrules.md` dice `UI/`, pero `Library` y `Search` usan `Presentation/Views/` | Estandarizar en `Presentation/Views/`; actualizar `localrules.md`; mover `Player/UI/` | bajo (doc) + medio (código) |
| 3 | **`Home` incompleto**: carpeta `Presentation/View/` en singular; sin `Domain/`/`Data/` (datos hardcodeados en los ViewModels); **no está cableado en el TabBar** (el tab Home renderiza el Player) | Renombrar `View/` → `Views/`; decidir si `Home` tendrá capa de dominio/datos o queda presentation-only (documentarlo); re-cablear el tab Home a `HomeView` | medio |
| 4 | **`Login` incompleto**: 7 carpetas Clean vacías; `LoginViewModel()` se instancia directo en la vista (sin CompositionRoot); `Data/Mappers/` (nombre que no se usa en el resto del repo) | Implementar el stack o borrar el scaffolding; agregar `LoginCompositionRoot`; eliminar `Mappers/` (el mapeo va en `DTO.toDomain()` / `Model.init(from:)`) | bajo–medio |
| 5 | **Nombre del composition root**: `LibraryCompositionRoot` / `PlayerCompositionRoot` vs `SearchFactory` | Renombrar `SearchFactory` → `SearchCompositionRoot` | bajo |
| 6 | **Estrategia de mock dispar**: `Library` hardcodea en `MockLibraryRepository`; `Search` hardcodea en `SearchRepository` (nombre de prod) con DTOs sin usar y sin JSON; `Player` usa `MockPlayerDataSource` + `Data/Mock/MockTrack.json` (cumple la regla) | Alinear `Library` y `Search` al patrón `DataSource` + JSON en `Data/Mock/` | medio |
| 7 | **Colores duplicados**: catálogo `resources/colors/*` + statics en `Color+Extensions.swift` + literal `Color("#121212")` en `HomeView` | Migrar `primaryBackground` / `cardBackground` a `.colorset`; borrar los statics; corregir literales | bajo |
| 8 | **Catálogo de assets desordenado**: `.svg`/`.png` sueltos (sin `.imageset`, Xcode los ignora) en la raíz y en `mock_resources/`; duplicados (`spotify-logo.svg` suelto + `spotify-logo.imageset`); 3 esquemas paralelos (raíz, `resources/`, `mock_resources/`). El diff staged actual repite el patrón (íconos de player sueltos **y** en `mock_resources/`) | Consolidar: assets reales en `resources/`, fixtures en `mock_resources/`, **todo** en `.imageset`; borrar sueltos y duplicados; rehacer el diff staged | medio |
| 9 | **Fuentes sin registrar**: `Info.plist` `UIAppFonts` lista 8 de 10 `.otf` (faltan `CircularStd-Black.otf`, `CircularStd-BookItalic.otf`) | Registrar los 10 archivos; verificar PostScript names reales (ojo `"CircularStd-Light Italic.otf"` con espacio vs `CircularStd-LightItalic`) | bajo |
| 10 | **Networking sin uso**: `Data/Networking` + `Infrastructure/Networking` completos pero ningún repo hace llamadas reales; typo `HTTPCLient` en el nombre del protocolo | Mantener como el camino "datos reales"; corregir el typo (`HTTPClient`); documentar que los repos concretos deben depender de él al conectar backend | bajo |
| 11 | **Los targets de test incluyen el código de la app** vía membership del synchronized group, con listas de excepción frágiles (ya listan `LibraryView`, `SearchView` y las 10 fuentes) | Quitar la membership de la carpeta `SpotifyCloneIA` de `SpotifyCloneIATests` y `SpotifyCloneIAUITests`; depender solo de `@testable import SpotifyCloneIA` | bajo (pero toca `.pbxproj`) |
| 12 | **5 homes para "código compartido"**: `Application/Common/`, `Data/Networking/`, `Infrastructure/`, `Presentation/ViewModels/`, `UI/Views/` | Definir un único `Shared/` (o `Core/`): `Shared/{DesignSystem,Extensions,Networking}` y mover ahí extensiones, `FontsManager`, networking y VMs cross-feature | alto |
| 13 | Nombres de plantilla: `ContentView.swift` (no `RootView`); header `FigmaSplashScreenView` en `SplashScreenView.swift`; headers/autores inconsistentes | Renombres menores opcionales; unificar (o quitar) la plantilla de header | bajo |

**Orden sugerido de migración:** #9 y #11 (rápidos, bajo riesgo) → #7, #8 (recursos)
→ #5, #10 → #1, #3, #4 (feature por feature) → #2, #6 → #12 (transversal, el más caro).
