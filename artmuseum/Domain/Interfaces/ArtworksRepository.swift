//
//  ArtworksRepository.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import Foundation

/// Repository protocol defining the interface for fetching artwork data.
/// This follows the Dependency Inversion Principle - the Domain layer defines
/// the interface while the Data layer provides the implementation.
protocol ArtworksRepository {
    /// Fetches artworks associated with a specific exhibition
    /// - Parameter exhibitionID: The unique identifier of the exhibition
    /// - Returns: Array of Artwork domain entities
    /// - Throws: Error if the fetch operation fails
    func fetchArtworks(exhibitionID: Int) async throws -> [Artwork]
    
    /// Searches for artworks matching the given query
    /// - Parameter query: Search text to match against artwork data
    /// - Returns: Array of Artwork domain entities matching the search
    /// - Throws: Error if the search operation fails
    func searchArtworks(query: String) async throws -> [Artwork]
}
