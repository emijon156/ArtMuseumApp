//
//  SearchViewModel.swift
//  artmuseum
//
//  Created by Emily Jon on 1/25/26.
//


import SwiftUI
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var results: [Artwork] = []
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .relevance
    
    private let repository = DefaultArtworksRepository()
    
    enum SortOption: String, CaseIterable, Identifiable {
        case relevance = "Relevance"
        case newest = "Newest Date"
        case oldest = "Oldest Date"
        case alphabetical = "A-Z"
        
        var id: String { self.rawValue }
    }
    
    
    /// Sorts the search results array based on the currently selected sort option.
    ///
    /// This method modifies the `results` array in-place using one of four sorting strategies:
    /// - `.relevance`: No sorting applied; results remain in API-returned order
    /// - `.newest`: Sorts by date in descending order (most recent first), using lexicographic comparison
    /// - `.oldest`: Sorts by date in ascending order (oldest first), using lexicographic comparison
    /// - `.alphabetical`: Sorts by artwork title in ascending alphabetical order (A-Z)
    ///
    /// - Note: Date sorting treats nil dates as empty strings, which will sort to the beginning.
    ///         The date format is expected to be ISO 8601 compatible for proper lexicographic sorting.
    func sortResults() {
        switch sortOption {
        case .relevance:
            break
        case .newest:
            results.sort { ($0.date ?? "") > ($1.date ?? "") }
        case .oldest:
            results.sort { ($0.date ?? "") < ($1.date ?? "") }
        case .alphabetical:
            results.sort { $0.title < $1.title }
        }
    }
    
    
    /// Performs an asynchronous artwork search using the current search text.
    ///
    /// This method orchestrates the complete search workflow:
    /// 1. Validates that searchText is not empty
    /// 2. Adds the query to search history via SearchHistoryManager
    /// 3. Sets loading state and fetches results from the repository
    /// 4. Applies the current sort option to the fetched results
    /// 5. Handles errors by clearing results and printing to console
    ///
    /// - Note: This is a `@MainActor` function that updates UI-related published properties.
    ///         Search queries are saved to history even if the API request fails.
    ///
    /// - SeeAlso: `sortResults()` for details on how results are sorted after fetching
    func search() async {
        guard !searchText.isEmpty else { return }
        
        //Save to history
        SearchHistoryManager.shared.add(searchText)
        
        isLoading = true
        
        do {
            //Fetch from API
            let fetched = try await repository.searchArtworks(query: searchText)
            
            //Apply Sort immediately
            //We assign the fetched results first, then sort them in place
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
