//
//  DefaultExhibitionsRepository.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import Foundation

/// Concrete implementation of ExhibitionsRepository that fetches data from the
/// Harvard Art Museums API. This class handles API communication, data decoding,
/// and mapping from DTOs to domain entities.
final class DefaultExhibitionsRepository: ExhibitionsRepository {
    
    private let apiKey = APIConfig.apiKey
    private let baseURL = "https://api.harvardartmuseums.org/exhibition"
    
    /// Fetches exhibitions from the Harvard Art Museums API
    /// - Returns: Array of Exhibition domain entities
    /// - Throws: URLError if the request fails or response is invalid
    func fetchExhibitions() async throws -> [Exhibition] {
        // Build URL with query parameters
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "sort", value: "chronological"),
            URLQueryItem(name: "sortorder", value: "desc"),
            URLQueryItem(name: "hasimage", value: "1") // Only exhibitions with images
        ]
        
        guard let url = components.url else { throw URLError(.badURL) }
        
        // Fetch data from API
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Decode API response (DTO)
        let decoder = JSONDecoder()
        let dto = try decoder.decode(ExhibitionPageDTO.self, from: data)
        
        // Map DTOs to Domain entities
        return dto.records.map { $0.toDomain() }
    }
}
