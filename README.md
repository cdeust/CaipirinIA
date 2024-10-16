# CaipirinIA

CaipirinIA is a mobile application that leverages machine learning and the CocktailDB API to identify ingredients through camera input and suggest cocktail recipes based on detected ingredients. The project follows best practices in mobile application architecture, focusing on scalability, maintainability, and clean code principles.

## Table of Contents

1. [Project Structure](#project-structure)
2. [Architectural Overview](#architectural-overview)
3. [Design Patterns](#design-patterns)
4. [Dependency Management](#dependency-management)
5. [View and UI Components](#view-and-ui-components)
6. [Machine Learning Integration](#machine-learning-integration)
7. [API and Networking](#api-and-networking)
8. [Contribution Guidelines](#contribution-guidelines)

## Project Structure

The project is organized into several modules and folders, each serving a distinct purpose:

- `AppState`: Manages global state across the application.
- `Classifier`: Handles machine learning classification tasks.
- `ContentView`: The primary view of the app, structured with SwiftUI components.
- `DependencyContainer`: Implements dependency injection for the app.
- `FrameProcessor`: Processes camera frames for object detection.

### Folders:
- `Constants`: Stores constants used throughout the app.
- `Effects`: Holds effects like animations and transitions.
- `Extensions`: Contains helper extensions for various classes.
- `Managers`: Coordinates tasks such as data management and state handling.
- `Mapper`: Handles transformations between different data models.
- `ML`: Contains machine learning-related files.
- `Models`: Data models representing cocktails and ingredients.
- `ViewModels`: Implements the MVVM pattern, connecting views with the business logic.
- `Services`: Manages external services such as network requests to the CocktailDB API.
- `Utilities`: General-purpose utilities and helpers.
- `Views`: Contains SwiftUI-based UI components and view layouts.
- `Assets`: Stores static resources like images and icons.

## Architectural Overview

CaipirinIA follows a **Model-View-ViewModel (MVVM)** architecture pattern. This pattern was chosen for its clear separation of concerns, ease of testing, and improved scalability. Below is a breakdown of the key architectural components:

- **Model**: Represents the application's data, including objects such as `Cocktail` and `Ingredient`.
- **ViewModel**: Acts as the intermediary between the view and the model, responsible for preparing data for display and handling user input.
- **View**: Built with SwiftUI, the views react to changes in the `ViewModel`, updating the UI automatically based on the state.

The MVVM architecture ensures that the business logic is decoupled from the user interface, making the app easier to maintain and test as it grows.

## Design Patterns

- **Dependency Injection**: Managed by `DependencyContainer`, this pattern allows for loose coupling between classes and makes unit testing simpler by providing mock implementations.
- **Factory Pattern**: Used in places such as object creation to ensure that specific configurations are provided when initializing components (e.g., `CocktailService`).
- **Coordinator Pattern**: The app uses a custom navigation mechanism to manage view transitions and user flow, which allows for a clean separation between UI and navigation logic.
- **State Management**: The global state is managed through the `AppState` class, which acts as a centralized store for the application's state, reducing the complexity of passing state between views.

## Dependency Management

CaipirinIA uses **Koin** for dependency injection in Kotlin-based components and custom `DependencyContainer` in Swift to ensure decoupled service management across the app. This approach allows for better testing, as dependencies can be mocked or injected at runtime without tight coupling.

- **Moshi**: Used for JSON serialization and deserialization in the networking layer.
- **Koin**: Ensures that services are injected with minimal setup and clean lifecycle management.

## View and UI Components

### SwiftUI and Custom Views

The UI is built with **SwiftUI**, which enables a declarative approach to UI development. Components are broken down into reusable views, making them easy to maintain and test. Key views include:

- **Home View**: Displays recent cocktails and ingredients.
- **Camera View**: Uses `FrameProcessor` to detect ingredients in real-time, with a circular button to start detection and a dynamic progress gauge when an ingredient is recognized.
- **Cocktail List View**: Shows a list of cocktails based on detected ingredients.
- **Cocktail Detail View**: Displays detailed information about a selected cocktail.

UI navigation is managed through a custom `FakeTabBar` implementation, where the `CircularNavigationButton` leads to the `CameraView`.

## Machine Learning Integration

The app integrates machine learning models via the `Classifier` class and `FrameProcessor`, enabling real-time object detection for ingredients. The `FrameProcessor` captures camera frames and passes them to the `Classifier`, which identifies ingredients and triggers updates in the UI.

The app uses **CoreML** for iOS to ensure fast, on-device inference for ingredient detection. Models are stored in the `ML` directory and can be updated as new data is gathered.

## API and Networking

The app connects to the **CocktailDB API** to fetch cocktail recipes based on identified ingredients. Networking is handled via the `CocktailServiceProtocol`, with `Endpoint` classes defining specific API requests.

The **Moshi** library is used for parsing JSON responses from the API, and responses are mapped to the corresponding models in the app using the `Mapper` classes.

Error handling and network status monitoring are built into the services layer, ensuring that the app can gracefully handle connectivity issues.

## Contribution Guidelines

We welcome contributions to improve CaipirinIA! If you would like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch (`feature/your-feature`).
3. Write tests for any new functionality.
4. Submit a pull request with a detailed explanation of your changes.

All contributions should follow the MVVM pattern and aim to improve code scalability and maintainability.

## License

CaipirinIA is released under the MIT License. See the [LICENSE](./LICENSE) file for more information.
