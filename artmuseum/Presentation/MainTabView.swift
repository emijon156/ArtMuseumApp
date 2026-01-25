//
//  MainTabView.swift
//  artmuseum
//
//  Created by Emily Jon on 1/25/26.
//


import SwiftUI

struct MainTabView: View {
    let exhibitionsViewModel: ExhibitionListViewModel
    let searchViewModel: SearchViewModel
    
    var body: some View {
        TabView {
            // Tab 1: Browse
            ExhibitionListView(viewModel: exhibitionsViewModel)
                .tabItem {
                    Label("Browse", systemImage: "square.grid.2x2")
                }
            
            // Tab 2: Favorites
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            
            // Tab 3: Search
            SearchView(viewModel: searchViewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}
