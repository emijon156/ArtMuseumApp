//
//  SearchViewModel.swift
//  artmuseum
//
//  Created by Emily Jon on 1/25/26.
//

import SwiftUI
import Combine

/// ViewModel for the search screen.
/// Manages the state and business logic for searching artworks and sorting results.
/// Automatically saves search queries to history for user convenience.
@MainActor
class SearchViewModel: ObservableObject {
    
    /// Published search text binding to the search bar
    @Published var searchText: String = ""
    
    /// Published array of search results that triggers UI updates
    @Published var results: [Artwork] = []
    
    /// Published loading state indicator
    @Published var isLoading: Bool = false
    
    /// Published sort option that can be changed by the user
    @Published var sortOption: SortOption = .relevance
    
    private let repository = DefaultArtworksRepository()
    
    /// Available sorting options for search results
    enum SortOption: String, CaseIterable, Identifiable {
        case relevance = "Relevance"
        case newest = "Newest Date"
        case oldest = "Oldest Date"
        case alphabetical = "A-Z"
        
        var id: String { self.rawValue }
    }
    
    /// Sorts the current results based on the selected sort option
    func sortResults() {
        switch sortOption {
        case .relevance:
            break // Keep API's relevance order
        case .newest:
            results.sort { ($0.date ?? "") > ($1.date ?? "") }
        case .oldest:
            results.sort { ($0.date ?? "") < ($1.date ?? "") }
        case .alphabetical:
            results.sort { $0.title < $1.title }
        }
    }
    
    /// Performs a search for artworks matching the current search text
    /// Saves the search query to history and applies the current sort option
    func search() async {
        guard !searchText.isEmpty else { return }
        
        // Save search query to history
        SearchHistoryManager.shared.add(searchText)
        
        isLoading = true
        
        do {
            // Fetch results from API
            let fetched = try await repository.searchArtworks(query: searchText)
            
            // Store results and apply current sort
            self.results = fetched
            sortResults()
            
            isLoading = false
        } catch {
            print("Search error: \(error.localizedDescription)")
            self.results = []
            isLoading = false
        }
    }
}
