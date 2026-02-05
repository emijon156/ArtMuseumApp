//
//  DefaultArtworksRepository.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import Foundation

/// Concrete implementation of ArtworksRepository that fetches data from the
/// Harvard Art Museums API. This class handles API communication, data decoding,
/// and mapping from DTOs to domain entities.
final class DefaultArtworksRepository: ArtworksRepository {
    
    private let apiKey = APIConfig.apiKey
    private let baseURL = "https://api.harvardartmuseums.org/object"
    
    /// Fetches artworks associated with a specific exhibition
    /// - Parameter exhibitionID: The unique identifier of the exhibition
    /// - Returns: Array of Artwork domain entities
    /// - Throws: URLError if the request fails or response is invalid
    func fetchArtworks(exhibitionID: Int) async throws -> [Artwork] {
        var components = URLComponents(string: baseURL)!
        
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "exhibition", value: String(exhibitionID)), // Filter by exhibition
            URLQueryItem(name: "hasimage", value: "1"), // Only items with images
            URLQueryItem(name: "size", value: "50") // Limit to 50 items
        ]
        
        guard let url = components.url else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let pageDTO = try decoder.decode(ArtworkPageDTO.self, from: data)
        
        // Map DTOs to Domain entities
        return pageDTO.records.map { $0.toDomain() }
    }
    
    /// Searches for artworks matching the given query text
    /// - Parameter query: Search text to match against artwork data
    /// - Returns: Array of Artwork domain entities matching the search
    /// - Throws: URLError if the request fails or response is invalid
    func searchArtworks(query: String) async throws -> [Artwork] {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "q", value: query), // 'q' is the API's search parameter
            URLQueryItem(name: "hasimage", value: "1"),
            URLQueryItem(name: "size", value: "20") // Limit search results
        ]
        
        guard let url = components.url else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let pageDTO = try decoder.decode(ArtworkPageDTO.self, from: data)
        
        // Map DTOs to Domain entities
        return pageDTO.records.map { $0.toDomain() }
    }
}