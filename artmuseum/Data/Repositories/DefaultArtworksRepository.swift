//
//  DefaultArtworksRepository.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//


import Foundation

final class DefaultArtworksRepository: ArtworksRepository {
    
    private let apiKey = APIConfig.apiKey
    private let baseURL = "https://api.harvardartmuseums.org/object"
    
    /// Fetches artworks associated with a specific exhibition from the Harvard Art Museums API.
    ///
    /// This method constructs and executes an API request with the following parameters:
    /// - `apikey`: Authentication key from APIConfig
    /// - `exhibition`: Filters results to only artworks in the specified exhibition
    /// - `hasimage`: Set to "1" to exclude artworks without images
    /// - `size`: Limits response to 50 artworks maximum
    ///
    /// - Parameter exhibitionID: The unique identifier of the exhibition to query
    /// - Returns: An array of `Artwork` domain objects mapped from the API response
    /// - Throws: `URLError.badURL` if URL construction fails, `URLError.badServerResponse`
    ///           if the HTTP status is not 200, or decoding errors if the response format is invalid
    ///
    /// - Note: The Harvard Art Museums API requires a valid API key configured in APIConfig.
    ///         Results are automatically mapped from DTO (Data Transfer Object) format to
    ///         domain model format using the `toDomain()` transformation.
    func fetchArtworks(exhibitionID: Int) async throws -> [Artwork] {
        var components = URLComponents(string: baseURL)!
        
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "exhibition", value: String(exhibitionID)), // Filter by this exhibition
            URLQueryItem(name: "hasimage", value: "1"), // Only show items with images
            URLQueryItem(name: "size", value: "50") // Get 50 items
        ]
        
        guard let url = components.url else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let pageDTO = try decoder.decode(ArtworkPageDTO.self, from: data)
        
        return pageDTO.records.map { $0.toDomain() }
    }
    
    /// Searches for artworks across the Harvard Art Museums collection using a text query.
    ///
    /// This method performs a full-text search of the museum's collection with the following parameters:
    /// - `apikey`: Authentication key from APIConfig
    /// - `q`: The search query string (searches across multiple fields including title, artist, description)
    /// - `hasimage`: Set to "1" to only return artworks with available images
    /// - `size`: Limits response to 20 artworks maximum
    ///
    /// - Parameter query: The search text to query against the collection
    /// - Returns: An array of `Artwork` domain objects matching the search query
    /// - Throws: `URLError.badURL` if URL construction fails, `URLError.badServerResponse`
    ///           if the HTTP status is not 200, or decoding errors if the response format is invalid
    ///
    /// - Note: The search is performed server-side by the Harvard Art Museums API and uses
    ///         their internal search algorithm for relevance ranking. Results are returned in
    ///         order of relevance by default.
    func searchArtworks(query: String) async throws -> [Artwork] {
            var components = URLComponents(string: baseURL)!
            components.queryItems = [
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "q", value: query), // 'q' is the search parameter
                URLQueryItem(name: "hasimage", value: "1"),
                URLQueryItem(name: "size", value: "20")
            ]
            
            guard let url = components.url else { throw URLError(.badURL) }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            let pageDTO = try decoder.decode(ArtworkPageDTO.self, from: data)
            return pageDTO.records.map { $0.toDomain() }
        }
}


