//
//  artmuseumApp.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import SwiftUI

// App entry point using @main attribute to mark as the app's starting point
@main
struct HarvardArtMuseumApp: App {
    var body: some Scene {
        WindowGroup {
            // 1. Setup Dependencies - Creates repository instances for data layer
            // These handle network requests to Harvard Art Museums API
            let exhibitionsRepo = DefaultExhibitionsRepository()
            let artworksRepo = DefaultArtworksRepository()
            
            // Create use case that encapsulates business logic for browsing exhibitions
            let browseUseCase = DefaultBrowseExhibitionsUseCase(repository: exhibitionsRepo)
            
            // 2. Setup ViewModels - Initialize view models with their dependencies
            // HomeVM manages state for the exhibitions browse tab
            let homeVM = ExhibitionListViewModel(useCase: browseUseCase)
            let searchVM = SearchViewModel()
            
            // 3. Launch Main Tab View - Creates the root view with three tabs:
            // Browse, Favorites, and Search
            MainTabView(exhibitionsViewModel: homeVM, searchViewModel: searchVM)
        }
    }
}

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

