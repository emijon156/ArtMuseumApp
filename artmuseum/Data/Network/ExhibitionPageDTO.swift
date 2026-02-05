//
//  ExhibitionPageDTO.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import Foundation

/// Data Transfer Object representing the API response wrapper for exhibitions.
/// DTOs are used to decode JSON responses from the API and are kept separate
/// from domain entities to maintain separation of concerns.
struct ExhibitionPageDTO: Decodable {
    /// Array of exhibition records from the API response
    let records: [ExhibitionDTO]
}

/// Data Transfer Object matching the JSON structure of an exhibition from the API.
/// Field names match the Harvard Art Museums API response format.
struct ExhibitionDTO: Decodable {
    let exhibitionid: Int
    let title: String
    let description: String?
    let begindate: String?
    let enddate: String?
    let primaryimageurl: String?
}

/// Extension to convert API DTOs to domain entities.
/// This mapping keeps the domain layer independent of external API structures.
extension ExhibitionDTO {
    func toDomain() -> Exhibition {
        return Exhibition(
            id: exhibitionid,
            title: title,
            description: description,
            beginDate: begindate,
            endDate: enddate,
            imageUrl: URL(string: primaryimageurl ?? "")
        )
    }
}
