//
//  ExhibitionPageDTO.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//


import Foundation

//API Response Wrapper
struct ExhibitionPageDTO: Decodable {
    let records: [ExhibitionDTO]
}

//JSON object
struct ExhibitionDTO: Decodable {
    let exhibitionid: Int
    let title: String
    let description: String?
    let begindate: String?
    let enddate: String?
    let primaryimageurl: String?
}

extension ExhibitionDTO {
    /// Transforms an API Data Transfer Object (DTO) into a domain-layer Exhibition entity.
    ///
    /// This method maps the raw JSON structure from the Harvard Art Museums API to the
    /// application's internal domain model with the following transformations:
    /// - `exhibitionid` → `id`: Maps the API's exhibition identifier
    /// - `title`, `description`, `begindate`, `enddate`: Direct field mappings with optional handling
    /// - `primaryimageurl` → `imageUrl`: Converts string to URL, with nil fallback for invalid URLs
    ///
    /// - Returns: A fully constructed `Exhibition` domain object ready for use in the presentation layer
    ///
    /// - Note: Invalid or missing image URLs will result in a nil URL, which the UI handles with
    ///         placeholder images or default graphics.
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
