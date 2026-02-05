//
//  FavoritesManager.swift
//  artmuseum
//
//  Created by Emily Jon on 1/25/26.
//


import Foundation
import Combine

class FavoritesManager: ObservableObject {
    // Shared instance
    static let shared = FavoritesManager()
    
    @Published var savedArtworks: [Artwork] = []
    
    private let key = "saved_artworks"
    
    private init() {
        load()
    }
    
    /// Checks whether an artwork is currently in the favorites collection.
    ///
    /// This method performs an ID-based lookup to determine if the given artwork
    /// has been previously saved to favorites. It's a read-only operation that doesn't
    /// modify any state.
    ///
    /// - Parameter artwork: The artwork to check for favorite status
    /// - Returns: `true` if an artwork with matching ID exists in savedArtworks, `false` otherwise
    ///
    /// - Note: Comparison is based solely on artwork ID, not on other properties like
    ///         title or artist. This ensures consistent behavior even if artwork details
    ///         are updated in the API.
    ///
    /// - SeeAlso: `toggle(_:)` to modify favorite status
    // Check if an artwork is already saved
    func contains(_ artwork: Artwork) -> Bool {
        savedArtworks.contains { $0.id == artwork.id }
    }
    
    /// Toggles the favorite status of an artwork.
    ///
    /// This method implements add/remove logic for the favorites collection:
    /// - If the artwork already exists in `savedArtworks` (matched by ID), it is removed
    /// - If the artwork is not present, it is appended to the end of the collection
    /// - Changes are automatically persisted to UserDefaults after each toggle
    ///
    /// - Parameter artwork: The artwork to add or remove from favorites
    ///
    /// - Note: This method has side effects - it modifies the published `savedArtworks` array
    ///         and triggers a save operation to disk. Changes will be reflected across all
    ///         instances due to the shared singleton pattern.
    ///
    /// - SeeAlso: `contains(_:)` to check favorite status without modifying state
    // Toggle: If saved, remove it. If new, save it.
    func toggle(_ artwork: Artwork) {
        if contains(artwork) {
            savedArtworks.removeAll { $0.id == artwork.id }
        } else {
            savedArtworks.append(artwork)
        }
        save()
    }
    
    // Save to disk (UserDefaults)
    private func save() {
        if let encoded = try? JSONEncoder().encode(savedArtworks) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    // Load from disk
    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Artwork].self, from: data) {
            savedArtworks = decoded
        }
    }
}
