//
//  artmuseumApp.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import SwiftUI

/// The main entry point for the Harvard Art Museum iOS application.
/// This struct defines the app structure using SwiftUI's App protocol.
/// The @main attribute marks this as the app's entry point.
@main
struct HarvardArtMuseumApp: App {
    /// Defines the app's scene configuration.
    /// SwiftUI uses Scene-based architecture where the body property returns one or more scenes.
    var body: some Scene {
        /// WindowGroup creates a scene that presents a group of identically structured windows.
        /// For iOS, this typically creates a single window for the app.
        WindowGroup {
            // === 1. Dependency Injection: Initialize Data Repositories ===
            // Repositories handle data fetching from the Harvard Art Museums API
            // These follow the Repository pattern to abstract data sources
            let exhibitionsRepo = DefaultExhibitionsRepository()
            let artworksRepo = DefaultArtworksRepository()
            
            // === 2. Use Case Setup: Business Logic Layer ===
            // Use cases encapsulate business logic and coordinate between repositories and view models
            // This follows Clean Architecture principles for separation of concerns
            let browseUseCase = DefaultBrowseExhibitionsUseCase(repository: exhibitionsRepo)
            
            // === 3. View Model Initialization: Presentation Layer ===
            // View models manage UI state and handle user interactions
            // They bridge the gap between use cases (domain layer) and views (presentation layer)
            let homeVM = ExhibitionListViewModel(useCase: browseUseCase)
            let searchVM = SearchViewModel()
            
            // === 4. Root View: Launch Main Tab View ===
            // MainTabView is the root view containing three tabs:
            // - Browse: Displays exhibitions using the homeVM
            // - Favorites: Shows user's saved artworks
            // - Search: Provides artwork search functionality using searchVM
            MainTabView(exhibitionsViewModel: homeVM, searchViewModel: searchVM)
        }
    }
}

/// A helper view for creating the exhibition list with proper SwiftUI lifecycle management.
/// This struct wraps ExhibitionListView and manages its view model as a StateObject.
/// Note: This view is currently unused as MainTabView directly instantiates ExhibitionListView.
private struct ExhibitionListRoot: View {
    let useCase: BrowseExhibitionsUseCase
    /// StateObject ensures the view model persists across view updates
    @StateObject private var viewModel: ExhibitionListViewModel

    /// Initializes the root view with a use case and creates its view model
    init(useCase: BrowseExhibitionsUseCase) {
        self.useCase = useCase
        // Using underscore prefix to initialize the @StateObject property wrapper
        _viewModel = StateObject(wrappedValue: ExhibitionListViewModel(useCase: useCase))
    }

    var body: some View {
        ExhibitionListView(viewModel: viewModel)
    }
}

