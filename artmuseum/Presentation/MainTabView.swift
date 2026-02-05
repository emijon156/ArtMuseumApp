//
//  MainTabView.swift
//  artmuseum
//
//  Created by Emily Jon on 1/25/26.
//

import SwiftUI

/// Root container view that provides the main tab-based navigation for the app.
/// This view manages three main features:
/// 1. Browse - View exhibitions from the Harvard Art Museums
/// 2. Favorites - View saved artworks
/// 3. Search - Search for specific artworks
struct MainTabView: View {
    let exhibitionsViewModel: ExhibitionListViewModel
    let searchViewModel: SearchViewModel
    
    var body: some View {
        TabView {
            // Tab 1: Browse exhibitions
            ExhibitionListView(viewModel: exhibitionsViewModel)
                .tabItem {
                    Label("Browse", systemImage: "square.grid.2x2")
                }
            
            // Tab 2: View favorite artworks
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            
            // Tab 3: Search artworks
            SearchView(viewModel: searchViewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}
