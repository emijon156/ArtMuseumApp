//
//  ArtworkPageDTO.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import Foundation

/// Data Transfer Object representing the API response wrapper for artworks.
/// DTOs are used to decode JSON responses from the API and are kept separate
/// from domain entities to maintain separation of concerns.
struct ArtworkPageDTO: Decodable {
    /// Array of artwork records from the API response
    let records: [ArtworkDTO]
}

/// Data Transfer Object matching the JSON structure of an artwork from the API.
/// Field names match the Harvard Art Museums API response format.
struct ArtworkDTO: Decodable {
    let objectid: Int
    let title: String
    let primaryimageurl: String?
    
    // Artwork metadata fields matching JSON exactly
    let dated: String?
    let medium: String?
    let department: String?
    let creditline: String?
    
    // Artist handling - nested array of people objects
    let people: [PersonDTO]?
    
    /// Nested DTO for artist information
    struct PersonDTO: Decodable { 
        let name: String 
    }
}

/// Extension to convert API DTOs to domain entities.
/// This mapping keeps the domain layer independent of external API structures.
extension ArtworkDTO {
    func toDomain() -> Artwork {
        // Extract first artist name or default to "Unknown Artist"
        let artistName = people?.first?.name ?? "Unknown Artist"
        
        return Artwork(
            id: objectid,
            title: title,
            artist: artistName,
            imageUrl: URL(string: primaryimageurl ?? ""),
            date: dated,
            medium: medium,
            department: department,
            creditLine: creditline
        )
    }
}
