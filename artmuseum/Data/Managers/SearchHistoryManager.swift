//
//  SearchHistoryManager.swift
//  artmuseum
//
//  Created by Emily Jon on 1/25/26.
//

import Foundation
import Combine

/// Singleton manager for tracking user's recent search queries.
/// Uses UserDefaults for persistent storage and publishes changes via Combine
/// to update the UI reactively.
class SearchHistoryManager: ObservableObject {
    /// Shared singleton instance accessible throughout the app
    static let shared = SearchHistoryManager()
    
    /// Published array of recent search terms (max 10) that triggers UI updates
    @Published var recentSearches: [String] = []
    
    private init() {
        // Load saved search history from UserDefaults on initialization
        recentSearches = UserDefaults.standard.stringArray(forKey: "recent_searches") ?? []
    }
    
    /// Adds a search query to the history, maintaining uniqueness and a max of 10 items
    /// - Parameter query: The search text to add
    func add(_ query: String) {
        guard !query.isEmpty else { return }
        
        // Remove duplicates (case-insensitive) and add to top
        var current = recentSearches
        current.removeAll { $0.lowercased() == query.lowercased() }
        current.insert(query, at: 0) // Add to top of list
        
        // Keep only the 10 most recent searches
        if current.count > 10 { 
            current = Array(current.prefix(10)) 
        }
        
        recentSearches = current
        UserDefaults.standard.set(recentSearches, forKey: "recent_searches")
    }
    
    /// Clears all search history
    func clear() {
        recentSearches = []
        UserDefaults.standard.removeObject(forKey: "recent_searches")
    }
}
