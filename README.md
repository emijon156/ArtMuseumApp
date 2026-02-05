# Harvard Art Museum App

An iOS app for exploring exhibitions and artworks from the Harvard Art Museums collection, built with SwiftUI and Clean Architecture principles.

## Architecture Overview

This app follows **Clean Architecture** with the **MVVM (Model-View-ViewModel)** pattern, organized into three distinct layers:

### 📦 Domain Layer
The core business logic layer, independent of any frameworks or external dependencies.

**Location:** `artmuseum/Domain/`

- **Entities** (`Domain/Entities/`)
  - `Artwork.swift` - Core artwork model with metadata
  - `Exhibition.swift` - Core exhibition model

- **Interfaces** (`Domain/Interfaces/`)
  - `ArtworksRepository.swift` - Protocol for artwork data operations
  - `ExhibitionsRepository.swift` - Protocol for exhibition data operations

- **Use Cases** (`Domain/UseCases/`)
  - `BrowseExhibitionsUseCase.swift` - Business logic for fetching exhibitions
  - `ViewExhibitionDetailUseCase.swift` - Business logic for fetching exhibition artworks

### 🔌 Data Layer
Handles data fetching, persistence, and transformation between external sources and domain entities.

**Location:** `artmuseum/Data/`

- **Network** (`Data/Network/`)
  - `ExhibitionPageDTO.swift` - Data Transfer Objects for exhibitions API
  - `ArtworkPageDTO.swift` - Data Transfer Objects for artworks API

- **Repositories** (`Data/Repositories/`)
  - `DefaultExhibitionsRepository.swift` - Implementation of ExhibitionsRepository
  - `DefaultArtworksRepository.swift` - Implementation of ArtworksRepository

- **Managers** (`Data/Managers/`)
  - `FavoritesManager.swift` - Singleton for managing user's favorite artworks
  - `SearchHistoryManager.swift` - Singleton for managing search history

### 🎨 Presentation Layer
The UI layer built with SwiftUI, containing views and view models.

**Location:** `artmuseum/Presentation/`

- **ExhibitionList** - Browse exhibitions feature
  - `ExhibitionListView.swift` - Displays list of exhibitions with search
  - `ExhibitionListViewModel.swift` - Manages exhibition list state

- **ExhibitionDetail** - View exhibition details with artworks
  - `ExhibitionDetailView.swift` - Displays exhibition info and artworks
  - `ExhibitionDetailViewModel.swift` - Manages exhibition detail state

- **Search** - Search artworks feature
  - `SearchView.swift` - Search interface with history and results
  - `SearchViewModel.swift` - Manages search state and sorting

- **ArtworkDetail** - View individual artwork details
  - `ArtworkDetailView.swift` - Displays artwork info and metadata

- **FavoritesView.swift** - Displays saved favorite artworks

- **MainTabView.swift** - Root tab navigation container

### 🚀 App Entry Point
- `artmuseumApp.swift` - Main app entry point with dependency injection setup

## Key Features

### 🖼️ Browse Exhibitions
- View current and past exhibitions from Harvard Art Museums
- Search exhibitions by title or description
- Beautiful image-based cards with dates and descriptions

### 🔍 Search Artworks
- Search across the entire artwork collection
- Sort results by relevance, date, or alphabetically
- View recent search history

### ❤️ Favorites
- Save artworks to favorites
- Persistent storage using UserDefaults
- Quick access to saved artworks

### 📱 Exhibition Details
- View detailed exhibition information
- Browse artworks within an exhibition
- Search within exhibition artworks
- One-tap favorite artworks

### 🎭 Artwork Details
- High-resolution artwork images
- Comprehensive metadata (artist, date, medium, department, credit line)
- Share artwork functionality
- Toggle favorite status

## Data Flow

```
┌─────────────────────────────────────────────────────┐
│                 Presentation Layer                   │
│  (Views & ViewModels - SwiftUI, Combine)            │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│                   Domain Layer                       │
│     (Use Cases, Entities, Repository Protocols)     │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│                    Data Layer                        │
│  (Repository Implementations, DTOs, API, Storage)   │
└─────────────────────────────────────────────────────┘
```

1. **View** triggers an action (e.g., user taps "Browse")
2. **ViewModel** calls appropriate **Use Case**
3. **Use Case** requests data from **Repository** (protocol)
4. **Repository Implementation** fetches from API or local storage
5. **DTOs** are decoded from JSON and mapped to **Domain Entities**
6. **Entities** flow back up through Use Case to ViewModel
7. **ViewModel** updates published properties
8. **View** reactively updates UI

## External Dependencies

### Harvard Art Museums API
The app integrates with the [Harvard Art Museums API](https://harvardartmuseums.org/collections/api) to fetch:
- Exhibition data
- Artwork data
- High-resolution images

API Configuration: `APIConfig.apiKey` (referenced in repository implementations)

### Persistence
- **UserDefaults** - Used for storing favorites and search history
- **Combine** - Used for reactive state management in ViewModels and Managers

## Design Patterns

- **Clean Architecture** - Separation of concerns across layers
- **MVVM** - Separation of UI from business logic
- **Repository Pattern** - Abstraction of data sources
- **Dependency Injection** - ViewModels receive dependencies via initializers
- **Singleton Pattern** - Shared managers (FavoritesManager, SearchHistoryManager)
- **DTO Pattern** - Separation of API models from domain entities

## Code Organization Principles

1. **Dependency Inversion** - Domain layer defines interfaces, Data layer implements them
2. **Single Responsibility** - Each class/struct has one clear purpose
3. **Separation of Concerns** - UI, business logic, and data are independent
4. **Testability** - Protocol-based design enables easy mocking and testing

## References

This project's MVVM setup was inspired by [iOS-Clean-Architecture-MVVM](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM) by kudoleh. 
