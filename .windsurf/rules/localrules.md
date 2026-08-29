---
trigger: always_on
---

---
trigger: always_on
---

<feature_structure>
- All new features should be created inside the `SpotifyCloneIA/Features/` directory.
- All new features should follow the structure of the `Library` feature.
- The structure is as follows:
  - `CompositionRoot/`: For dependency injection.
  - `Data/`: For data sources, repositories, and DTOs.
  - `Domain/`: For entities, use cases, and interfaces.
  - `Presentation/`: For ViewModels and presentation models.
  - `UI/`: For SwiftUI views.
</feature_structure>

<development_flow>
- The development of a new feature should start from the data layer and move towards the presentation layer.
- The flow is as follows:
  1.  **Domain**: Define entities and use cases.
  2.  **Data**: Implement data sources and repositories.
  3.  **Presentation**: Create ViewModels.
  4.  **UI**: Build the SwiftUI views.
</development_flow>

<data_mocking>
- All data used for development and testing should be mocked.
- Mocked data should be stored in JSON files.
- JSON files should be located in a `Mock` folder inside the `Data` layer of the feature.
</data_mocking>

<resources>
- **Fonts**: All fonts must be consumed using the `FontsManager`.
  - Use `FontsManager.circular(_:size:)` for custom fonts.
  - Example: `.font(.circular(.bold, size: 22))`
- **Colors and Images**: All colors and images must be consumed from the `SpotifyCloneIA/Assets.xcassets` file.
  - Use `Color("colorName")` for colors.
  - Use `Image("imageName")` for images.
</resources>