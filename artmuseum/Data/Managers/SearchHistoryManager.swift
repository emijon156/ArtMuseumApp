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
    
    func clear() {
        recentSearches = []
        UserDefaults.standard.removeObject(forKey: "recent_searches")
    }
}
