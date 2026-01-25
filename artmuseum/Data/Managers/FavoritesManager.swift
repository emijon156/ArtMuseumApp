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
    
    // Check if an artwork is already saved
    func contains(_ artwork: Artwork) -> Bool {
        savedArtworks.contains { $0.id == artwork.id }
    }
    
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
