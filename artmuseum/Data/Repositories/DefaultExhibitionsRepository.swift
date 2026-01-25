//
//  DefaultExhibitionsRepository.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//


import Foundation

final class DefaultExhibitionsRepository: ExhibitionsRepository {
    
   
    private let apiKey = APIConfig.apiKey
    private let baseURL = "https://api.harvardartmuseums.org/exhibition"
    
    func fetchExhibitions() async throws -> [Exhibition] {
        //Build URL
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "sort", value: "chronological"),
            URLQueryItem(name: "sortorder", value: "desc"),
            URLQueryItem(name: "hasimage", value: "1")
        ]
        
        guard let url = components.url else { throw URLError(.badURL) }
        
        //Fetch Data
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        //Decode DTO
        let decoder = JSONDecoder()
        let dto = try decoder.decode(ExhibitionPageDTO.self, from: data)
        
        //Map to Domain
        return dto.records.map { $0.toDomain() }
    }
}
