//
//  artmuseumApp.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import SwiftUI

@main
struct HarvardArtMuseumApp: App {
    var body: some Scene {
        WindowGroup {
            // 1. Setup Dependencies
            let exhibitionsRepo = DefaultExhibitionsRepository()
            let artworksRepo = DefaultArtworksRepository()
            
            let browseUseCase = DefaultBrowseExhibitionsUseCase(repository: exhibitionsRepo)
            
            // 2. Setup ViewModels
            let homeVM = ExhibitionListViewModel(useCase: browseUseCase)
            let searchVM = SearchViewModel()
            
            // 3. Launch Main Tab View
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

