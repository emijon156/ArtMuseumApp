//
//  artmuseumApp.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//
//  Main Entry Point: This file is the entry point for the Harvard Art Museum iOS app.
//  It implements Clean Architecture with MVVM pattern, setting up the dependency
//  injection and initializing the app's view hierarchy.
//
//  Architecture Overview:
//  - Data Layer: Repositories handle API calls to Harvard Art Museums
//  - Domain Layer: Use Cases contain business logic
//  - Presentation Layer: ViewModels and SwiftUI Views handle UI
//
//  Reference: https://github.com/kudoleh/iOS-Clean-Architecture-MVVM
//

import SwiftUI

/// Main application entry point marked with @main attribute.
/// This struct conforms to the App protocol and defines the app's scene configuration.
@main
struct HarvardArtMuseumApp: App {
    /// The app's scene definition. SwiftUI calls this to create the app's UI hierarchy.
    var body: some Scene {
        WindowGroup {
            // MARK: - Dependency Injection Setup
            // This is where we manually construct the dependency graph.
            // In a larger app, this might be handled by a DI container.
            
            // 1. Data Layer: Create repositories that handle data fetching
            // These repositories communicate with the Harvard Art Museums API
            let exhibitionsRepo = DefaultExhibitionsRepository()
            let artworksRepo = DefaultArtworksRepository()
            
            // 2. Domain Layer: Create use cases that contain business logic
            // Use cases act as intermediaries between repositories and view models
            let browseUseCase = DefaultBrowseExhibitionsUseCase(repository: exhibitionsRepo)
            
            // 3. Presentation Layer: Create view models that manage UI state
            // View models observe use cases and provide data to views
            let homeVM = ExhibitionListViewModel(useCase: browseUseCase)
            let searchVM = SearchViewModel()
            
            // 4. Launch the root view with dependency-injected view models
            // MainTabView is a TabView container with three tabs: Browse, Favorites, Search
            MainTabView(exhibitionsViewModel: homeVM, searchViewModel: searchVM)
        }
    }
}

/// MARK: - Unused Root View Wrapper
/// This is an alternative root view structure that was likely used during development.
/// It's kept here for reference but is not currently used in the app.
/// The app directly uses MainTabView instead of this wrapper.
private struct ExhibitionListRoot: View {
    let useCase: BrowseExhibitionsUseCase
    @StateObject private var viewModel: ExhibitionListViewModel

    init(useCase: BrowseExhibitionsUseCase) {
        self.useCase = useCase
        _viewModel = StateObject(wrappedValue: ExhibitionListViewModel(useCase: useCase))
    }

    var body: some View {
        ExhibitionListView(viewModel: viewModel)
    }
}

