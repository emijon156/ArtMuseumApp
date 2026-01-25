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
    
    func fetchArtworks(exhibitionID: Int) async throws -> [Artwork] {
        var components = URLComponents(string: baseURL)!
        
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "exhibition", value: String(exhibitionID)), // Filter by this exhibition
            URLQueryItem(name: "hasimage", value: "1"), // REQUIRED: Only show items with images
            URLQueryItem(name: "size", value: "50") // Get 50 items (default is only 10)
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


