//
//  artmuseumApp.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import SwiftUI

/// Main entry point for the Harvard Art Museum iOS app.
/// This app follows Clean Architecture with MVVM pattern:
/// - Domain layer: Entities, Use Cases, Repository Interfaces
/// - Data layer: Repository implementations, DTOs, Data Managers
/// - Presentation layer: Views and ViewModels
@main
struct HarvardArtMuseumApp: App {
    var body: some Scene {
        WindowGroup {
            // 1. Setup Dependencies (Data Layer)
            let exhibitionsRepo = DefaultExhibitionsRepository()
            let artworksRepo = DefaultArtworksRepository()
            
            // 2. Setup Use Cases (Domain Layer)
            let browseUseCase = DefaultBrowseExhibitionsUseCase(repository: exhibitionsRepo)
            
            // 3. Setup ViewModels (Presentation Layer)
            let homeVM = ExhibitionListViewModel(useCase: browseUseCase)
            let searchVM = SearchViewModel()
            
            // 4. Launch Main Tab View
            MainTabView(exhibitionsViewModel: homeVM, searchViewModel: searchVM)
        }
    }
}

/// Helper view for setting up the exhibition list with proper dependency injection.
/// Currently unused but demonstrates an alternative setup pattern.
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

