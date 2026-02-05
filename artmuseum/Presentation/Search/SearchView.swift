//
//  SearchView.swift
//  artmuseum
//
//  Created by Emily Jon on 1/25/26.
//

import SwiftUI

/// View for searching artworks across the entire Harvard Art Museums collection.
/// Features:
/// - Search bar with submit-on-enter functionality
/// - Recent search history displayed when idle
/// - Sortable search results (by relevance, date, or alphabetically)
/// - Loading and empty states
struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @ObservedObject var historyManager = SearchHistoryManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
                // Sort picker - only visible when there are results
                if !viewModel.results.isEmpty {
                    Picker("Sort", selection: $viewModel.sortOption) {
                        ForEach(SearchViewModel.SortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .onChange(of: viewModel.sortOption) { _, _ in
                        viewModel.sortResults()
                    }
                }
                
                // Main content area with three states: loading, history, or results
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Searching...")
                    Spacer()
                    
                } else if viewModel.searchText.isEmpty {
                    // Search history view - shown when no active search
                    List {
                        if historyManager.recentSearches.isEmpty {
                            Text("No recent searches")
                                .foregroundColor(.secondary)
                        } else {
                            Section("Recent Searches") {
                                ForEach(historyManager.recentSearches, id: \.self) { term in
                                    Button {
                                        viewModel.searchText = term
                                        Task { await viewModel.search() }
                                    } label: {
                                        HStack {
                                            Image(systemName: "clock")
                                                .foregroundColor(.gray)
                                            Text(term)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                } else {
                    // Search results list
                    if viewModel.results.isEmpty {
                        Spacer()
                        Text("No results found.").foregroundColor(.secondary)
                        Spacer()
                    } else {
                        List(viewModel.results) { artwork in
                            NavigationLink(destination: ArtworkDetailView(artwork: artwork)) {
                                HStack(spacing: 12) {
                                    // Artwork thumbnail
                                    AsyncImage(url: artwork.imageUrl) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } else {
                                            Color.gray.opacity(0.3)
                                        }
                                    }
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(5)
                                    .clipped()
                                    
                                    // Artwork info
                                    VStack(alignment: .leading) {
                                        Text(artwork.title)
                                            .font(.headline)
                                            .lineLimit(1)
                                        
                                        if let artist = artwork.artist, !artist.isEmpty {
                                            Text(artist)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                        }
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchText, prompt: "Search artworks...")
            .onSubmit(of: .search) {
                Task { await viewModel.search() }
            }
        }
    }
}