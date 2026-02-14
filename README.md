# City Events Explorer

A Flutter application for browsing, searching, and saving favourite city events. Built as a coding challenge demonstrating clean architecture, modern state management, and professional Flutter development practices.

## 📋 Overview

This application allows users to:

- Browse upcoming events loaded from local JSON data
- Search events by title
- Filter events by category and date range
- View detailed event information with map preview
- Save favourite events (persisted locally across app restarts)

**Challenge Duration:** 6-8 focused hours  
**Focus:** Code structure, architectural decisions, and implementation quality over pixel-perfect UI

## 🛠️ Tech Stack

| Technology | Purpose | Version |
|------------|---------|---------|
| **Flutter** | Cross-platform framework | 3.5.0 |
| **Dart** | Programming language | 3.5.0 |
| **flutter_bloc** | State management | 9.1.1 |
| **get_it** | Service locator for DI | 9.2.0 |
| **injectable** | DI code generation | 2.5.0 |
| **freezed** | Immutable models | 3.2.5 |
| **json_serializable** | JSON serialization | 6.8.0 |
| **go_router** | Declarative routing | 17.1.0 |
| **shared_preferences** | Local persistence | 2.3.3 |
| **flutter_map** | Map display | 8.2.2 |
| **latlong2** | Coordinates handling | 0.9.1 |
| **mocktail** | Testing mocks | 1.0.4 |
| **very_good_analysis** | Linting rules | 10.1.0 |

## 🏗️ Architecture

This project implements **Clean Architecture** with three distinct layers:

```
Presentation Layer (UI + BLoC)
         ↓
Domain Layer (Business Logic)
         ↓
Data Layer (Data Sources + Repositories)
```

### Key Principles

- **Dependency Rule:** Dependencies point inward (Data → Domain ← Presentation)
- **Domain Independence:** Core business logic has no Flutter dependencies
- **Testability:** Each layer can be tested in isolation
- **Separation of Concerns:** UI, business logic, and data access are cleanly separated

See [docs/ADR-001.md](docs/ADR-001.md) for detailed architectural decisions and rationale.

##  Getting Started

### Prerequisites

- Flutter SDK ≥3.5.0
- Dart SDK ≥3.5.0

Verify installation:
```bash
flutter --version
```

### Installation

*Detailed setup instructions will be added as development progresses.*

```bash
# Clone the repository
git clone https://github.com/arielsoriano/interview-fmj
cd interview-fmj

# Install dependencies
flutter pub get

# Generate code (Freezed, Injectable, JSON serialization)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the application
flutter run
```

## 🧪 Testing

The project includes comprehensive unit and widget tests covering domain logic, BLoCs, and UI components.

**Test Results:**
- ✅ **30 tests passing**
- ✅ Coverage report generated (`coverage/lcov.info`)

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/events/presentation/bloc/events_bloc_test.dart
```

## 🔍 Code Quality

### Linting

This project uses `very_good_analysis` for strict linting:

```bash
# Analyze code
flutter analyze

# Auto-fix issues where possible
dart fix --apply
```

### Formatting

```bash
# Format code
dart format lib/ test/ -l 80
```

## 📦 Functional Requirements

| ID | Requirement | Status |
|----|-------------|--------|
| FR-1 | Load events from local JSON file | ✅ Complete |
| FR-2 | Display scrollable list with pagination/lazy loading | ✅ Complete |
| FR-3 | Event detail screen with map preview and favourites | ✅ Complete |
| FR-4 | Persist favourite events locally | ✅ Complete |

## 🎯 Development Workflow

### Code Generation

When modifying Freezed models, Injectable annotations, or JSON serializable classes:

```bash
# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on file changes)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Git Workflow

This project follows [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New features
- `fix:` Bug fixes
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `docs:` Documentation changes
- `style:` Code formatting (no functional changes)
- `build:` Build system or dependencies
- `ci:` CI/CD changes
- `chore:` Other changes that don't modify src or test files

## 📚 Documentation

- **[ADR-001.md](docs/ADR-001.md)** - Architecture Decision Record with detailed rationale for all technical choices
- **[CHALLENGE.md](CHALLENGE.md)** - Original coding challenge requirements
- **Inline documentation** - Code includes comprehensive doc comments

## 🎨 Design Decisions Summary

### Why Clean Architecture?
Demonstrates architectural competence, testability, and separation of concerns (35% of evaluation).

### Why BLoC?
Explicit state management pattern that pairs naturally with Clean Architecture and is highly testable.

### Why GetIt + Injectable?
GetIt provides a service locator pattern for dependency injection, while Injectable automates the registration process through code generation. This combination eliminates manual DI setup boilerplate while maintaining type safety and compile-time verification.

### Why go_router?
Modern declarative routing that demonstrates knowledge of current Flutter best practices, despite being unnecessary for this small app.

### Why Freezed?
Immutable models eliminate entire classes of bugs and generate boilerplate code automatically.

See [ADR-001.md](docs/ADR-001.md) for complete rationale and trade-offs.

## 📄 License

MIT License - This is a coding challenge project.

---

