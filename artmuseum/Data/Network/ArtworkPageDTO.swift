//
//  ArtworkPageDTO.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//


import Foundation

//The Wrapper
struct ArtworkPageDTO: Decodable {
    let records: [ArtworkDTO]
}

//JSON Structure
struct ArtworkDTO: Decodable {
    let objectid: Int
    let title: String
    let primaryimageurl: String?
    
    // New Fields matching JSON exactly
    let dated: String?
    let medium: String?
    let department: String?
    let creditline: String?
    
    // Artist handling
    let people: [PersonDTO]?
    struct PersonDTO: Decodable { let name: String }
}

extension ArtworkDTO {
    /// Transforms an API Data Transfer Object (DTO) into a domain-layer Artwork entity.
    ///
    /// This method maps the raw JSON structure from the Harvard Art Museums API to the
    /// application's internal domain model with the following transformations:
    /// - `objectid` → `id`: Maps the API's object identifier
    /// - `people` → `artist`: Extracts the first person's name, or defaults to "Unknown Artist" if unavailable
    /// - `primaryimageurl` → `imageUrl`: Converts string to URL, with nil fallback for invalid URLs
    /// - Direct field mappings: `dated` → `date`, `medium`, `department`, `creditline` → `creditLine`
    ///
    /// - Returns: A fully constructed `Artwork` domain object ready for use in the presentation layer
    ///
    /// - Note: The "Unknown Artist" default ensures the UI always has displayable artist information.
    ///         Invalid or missing image URLs will result in a nil URL, which the UI handles with placeholder images.
    func toDomain() -> Artwork {
        let artistName = people?.first?.name ?? "Unknown Artist"
        
        return Artwork(
            id: objectid,
            title: title,
            artist: artistName,
            imageUrl: URL(string: primaryimageurl ?? ""),
            
            // Map new fields
            date: dated,
            medium: medium,
            department: department,
            creditLine: creditline
        )
    }
}
