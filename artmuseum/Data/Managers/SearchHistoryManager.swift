//
//  SearchHistoryManager.swift
//  artmuseum
//
//  Created by Emily Jon on 1/25/26.
//


import Foundation
import Combine

class SearchHistoryManager: ObservableObject {
    static let shared = SearchHistoryManager()
    @Published var recentSearches: [String] = []
    
    private init() {
        // Load saved searches from UserDefaults
        recentSearches = UserDefaults.standard.stringArray(forKey: "recent_searches") ?? []
    }
    
    /// Adds a search query to the search history with automatic deduplication and size limiting.
    ///
    /// This method implements the following behavior:
    /// 1. Ignores empty strings - no action is taken
    /// 2. Removes any existing case-insensitive match of the query from history
    /// 3. Inserts the new query at the beginning (index 0) of the history
    /// 4. Limits the history to a maximum of 10 items, removing older entries
    /// 5. Persists the updated history to UserDefaults with key "recent_searches"
    ///
    /// - Parameter query: The search string to add to history
    ///
    /// - Note: The deduplication is case-insensitive, but the original casing of the
    ///         new query is preserved. If the same query already exists with different
    ///         casing, it will be replaced and moved to the top.
    ///
    /// - Example:
    ///   ```swift
    ///   // Initial history: ["Monet", "Picasso", "Van Gogh"]
    ///   manager.add("MONET")
    ///   // Result: ["MONET", "Picasso", "Van Gogh"]
    ///   ```
    func add(_ query: String) {
        guard !query.isEmpty else { return }
        
        // Remove duplicates and keep only the last 10
        var current = recentSearches
        current.removeAll { $0.lowercased() == query.lowercased() }
        current.insert(query, at: 0) // Add to top
        
        if current.count > 10 { current = Array(current.prefix(10)) }
        
        recentSearches = current
        UserDefaults.standard.set(recentSearches, forKey: "recent_searches")
    }
    
    /// Clears the entire search history, removing all saved queries.
    ///
    /// This method performs two operations:
    /// 1. Empties the `recentSearches` array in memory
    /// 2. Removes the persisted data from UserDefaults using the "recent_searches" key
    ///
    /// - Note: This is a destructive operation with no undo. The UI should confirm with
    ///         the user before calling this method to prevent accidental data loss.
    func clear() {
        recentSearches = []
        UserDefaults.standard.removeObject(forKey: "recent_searches")
    }
}
