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
