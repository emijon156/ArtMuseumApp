# Harvard Art Museum App

An iOS application for browsing exhibitions and artworks from the Harvard Art Museums, built with SwiftUI and Clean Architecture principles.

## Architecture Overview

This app follows **Clean Architecture with MVVM** pattern, inspired by [this reference implementation](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/tree/master).

### Layer Structure

1. **Data Layer** (`Data/`)
   - **Repositories**: Handle data fetching from the Harvard Art Museums API
   - **Network**: DTOs (Data Transfer Objects) for API responses
   - **Managers**: Local data management (favorites, search history)

2. **Domain Layer** (`Domain/`)
   - **Entities**: Core business models (Exhibition, Artwork)
   - **Use Cases**: Business logic encapsulation
   - **Interfaces**: Protocols defining repository contracts

3. **Presentation Layer** (`Presentation/`)
   - **Views**: SwiftUI views for the UI
   - **ViewModels**: State management and presentation logic

### Main Entry Point

**File**: `artmuseumApp.swift`

The app initialization follows this flow:

```
1. Create Data Repositories (API communication layer)
   ↓
2. Create Domain Use Cases (business logic)
   ↓
3. Create Presentation ViewModels (UI state management)
   ↓
4. Launch MainTabView (root UI component)
```

**MainTabView** provides three main tabs:
- **Browse**: Displays a list of exhibitions from the Harvard Art Museums
- **Favorites**: Shows user-saved favorite artworks
- **Search**: Allows searching for specific artworks

### Dependency Injection

Dependencies are manually injected at app launch in `artmuseumApp.swift`. This approach:
- Makes dependencies explicit and traceable
- Keeps the architecture simple without requiring a DI framework
- Follows the dependency rule: outer layers depend on inner layers

### API Integration

The app uses the Harvard Art Museums API. An API key is required and should be configured in the API configuration file.

**Note**: The API configuration file has been removed for security. Contact the repository owner if you need access. 
