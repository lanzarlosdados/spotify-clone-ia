---
trigger: always_on
---

<feature_structure>
- All new features live in `SpotifyCloneIA/Features/<Feature>/`.
- Follow the structure of the `Library` feature (canonical reference):
  - `Domain/` — `Entities/`, `Repositories/` (protocols `<Feature>RepositoryProtocol`), `UseCases/` (`<Verb><Noun>UseCase`, one `execute`).
  - `Data/` — `DataSources/` (`<Feature>DataSource` protocol + `Mock<Feature>DataSource`), `DTOs/` (`Codable`, snake_case `CodingKeys`, `toDomain()`), `Repositories/` (`Default<Feature>Repository`), `Mock/` (JSON fixtures).
  - `Presentation/` — `ViewModels/` (`@Observable final class`), `Models/` (`<Thing>Model` + `init(from:)`), `Views/` with `Components/` / `Subviews/` / `Section/`.
  - `CompositionRoot/<Feature>CompositionRoot.swift` — singleton `.shared`, `make<X>ViewModel()` / `make<X>View()`, plus a testing overload that accepts a mock repo.
</feature_structure>

<app_and_shared>
- App shell (entry point, tab bar, splash, user menu) lives in `SpotifyCloneIA/App/`.
- Cross-feature code lives in `SpotifyCloneIA/Shared/`: `DesignSystem/`, `Extensions/`, `Networking/`.
- Do NOT recreate top-level `Application/`, `Data/`, `Infrastructure/`, `Presentation/` or `UI/` folders.
</app_and_shared>

<development_flow>
- Build a feature from the data layer towards the UI: **Domain → Data → Presentation → UI**.
</development_flow>

<data_mocking>
- All development/test data is mocked as JSON files in the feature's `Data/Mock/` folder,
  loaded by the `Mock<Feature>DataSource` via `Bundle.main`.
</data_mocking>

<resources>
- **Fonts**: consume only through `FontsManager` — `.font(.circular(.bold, size: 22))`.
  Never `Font.custom("...")` with a raw name.
- **Colors**: define a `.colorset` in `Assets.xcassets/resources/colors/` and use the
  generated symbol (`Color.spotifyGreen` / `Color("backgroundApp")`). Never hardcode
  `Color(red:green:blue:)` or `Color("#hex")`, and don't add static colors in Swift.
- **Images**: real UI assets as `.imageset` in `Assets.xcassets/resources/{icons,images}/`;
  mock/fixture imagery in `Assets.xcassets/mock_resources/images/`. Never drop loose
  `.svg`/`.png` at the catalog root.
</resources>

<view_models>
- ViewModels are `@Observable final class`, receive use cases via `init`.
- Views take the view model as `let` with `init(viewModel: VM? = nil)` falling back to
  the feature's `CompositionRoot`.
</view_models>
