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
