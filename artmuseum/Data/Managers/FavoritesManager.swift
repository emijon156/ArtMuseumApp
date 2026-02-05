//
//  FavoritesManager.swift
//  artmuseum
//
//  Created by Emily Jon on 1/25/26.
//

import Foundation
import Combine

/// Singleton manager for handling user's favorite artworks.
/// Uses UserDefaults for persistent storage and publishes changes via Combine
/// to update the UI reactively across the app.
class FavoritesManager: ObservableObject {
    /// Shared singleton instance accessible throughout the app
    static let shared = FavoritesManager()
    
    /// Published array of saved artworks that triggers UI updates when changed
    @Published var savedArtworks: [Artwork] = []
    
    private let key = "saved_artworks"
    
    private init() {
        load()
    }
    
    /// Checks if an artwork is already in the favorites list
    /// - Parameter artwork: The artwork to check
    /// - Returns: true if the artwork is saved, false otherwise
    func contains(_ artwork: Artwork) -> Bool {
        savedArtworks.contains { $0.id == artwork.id }
    }
    
    /// Toggles the favorite status of an artwork (add if new, remove if exists)
    /// - Parameter artwork: The artwork to toggle
    func toggle(_ artwork: Artwork) {
        if contains(artwork) {
            savedArtworks.removeAll { $0.id == artwork.id }
        } else {
            savedArtworks.append(artwork)
        }
        save()
    }
    
    /// Persists the favorites list to UserDefaults
    private func save() {
        if let encoded = try? JSONEncoder().encode(savedArtworks) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    /// Loads the favorites list from UserDefaults on initialization
    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Artwork].self, from: data) {
            savedArtworks = decoded
        }
    }
}
