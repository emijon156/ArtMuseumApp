//
//  SearchView.swift
//  artmuseum
//
//  Created by Emily Jon on 1/25/26.
//


import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    
    @ObservedObject var historyManager = SearchHistoryManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
                if !viewModel.results.isEmpty {
                    Picker("Sort", selection: $viewModel.sortOption) {
                        ForEach(SearchViewModel.SortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .onChange(of: viewModel.sortOption) { _ in
                        viewModel.sortResults()
                    }
                }
                
                //The Content Area
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Searching...")
                    Spacer()
                    
                } else if viewModel.searchText.isEmpty {
                    //SEARCH HISTORY VIEW
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
                    //RESULTS LIST
                    if viewModel.results.isEmpty {
                        Spacer()
                        Text("No results found.").foregroundColor(.secondary)
                        Spacer()
                    } else {
                        List(viewModel.results) { artwork in
                            NavigationLink(destination: ArtworkDetailView(artwork: artwork)) {
                                HStack(spacing: 12) {
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
