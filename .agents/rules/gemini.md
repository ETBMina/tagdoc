---
trigger: always_on
---

# Gemini Project Instructions: TagDoc

These instructions define the architectural constraints, coding standards, and communication protocols for this Flutter project. Gemini MUST always adhere to these rules when analyzing, modifying, or creating new code.

## 1. Interaction & Workflow Rules
- **No Assumptions:** Ask for clarification *before* starting implementation if anything is ambiguous or not fully defined. Do not make assumptions about business logic or architecture flow.
- **FVM Usage:** The project uses Flutter Version Management (FVM). Always use `fvm flutter` or `fvm dart` instead of `flutter` or `dart` when running shell commands.
- **Syntax Checks:** Always double-check for syntax errors, missing imports, or missing parameters at the end of each file edit.

## 2. Architecture: Clean Architecture + MVVM (via BLoC)
The project strictly follows a feature-first Clean Architecture, divided into three main layers: `Domain`, `Data`, and `Presentation`.

### A. Domain Layer (Inner Core)
- **Entities:** Pure Dart objects (`Equatable`) representing business concepts (e.g., `Movie`). No dependencies on Flutter, JSON, or third-party libraries (except `equatable`).
- **Repositories (Interfaces):** Abstract classes defining contracts (e.g., `BaseMovieRepository`). They return `Either<Failure, Entity>` using `fpdart`.
- **Use Cases:** Classes with a single responsibility using the `call()` method. They fetch data from Repositories and return `Either<Failure, Type>`.

### B. Data Layer
- **Models:** Extend `Entities` and include parsing logic (e.g., `fromJson`, `toJson`). Models *are* Entities, so repositories return them directly to satisfy the Domain contract without extra mapping when possible.
- **Data Sources:** Handle the actual data acquisition (e.g., `LocalFileDataSource`, `MovieMetadataDataSource`).
- **Repositories (Implementation):** Implement the Domain repository interfaces. They orchestrate between Data Sources, handle exceptions, and return `Right(Model)` or `Left(Failure)`.

### C. Presentation Layer (MVVM)
- **State Management:** BLoC (Business Logic Component) acts as the ViewModel.
- **BLoC Structure:** Consists of Events, States, and the BLoC class itself. BLoCs take Use Cases via constructor injection. Use factories for BLoCs in Dependency Injection to ensure a fresh state on navigation.
- **UI (Pages & Widgets):** Displays the State emitted by the BLoC and sends Events to the BLoC. Only depends on the BLoC, never directly on Use Cases or Repositories.

## 3. Core & Shared Utilities
- **Dependency Injection (DI):** Managed by `get_it` in `lib/init_dependencies.dart`.
  - Data Sources & Repositories: `registerLazySingleton`
  - Use Cases: `registerLazySingleton` (because they are stateless)
  - BLoCs: `registerFactory`
- **Error Handling:** Centralized `Failure` class and `ErrorMessages` constants in the `core` folder. Avoid hardcoding strings in the Data/Domain layers.
- **Functional Programming:** Use `fpdart`'s `Either` for error handling (`Left` for failures, `Right` for success/data) across repositories and use cases.

## 4. Implementation Checks
- **Dependency Rule:** Source code dependencies must ONLY point *inwards* toward the Domain layer. Domain knows nothing about Data or Presentation.
- If editing the Repository Implementation, ensure you do not import Domain UseCases unnecessarily unless it involves parameters defined within them.
- Ensure that constants (strings, route names) are centralized either in `lib/core/constants/` or feature-specific constant files.
