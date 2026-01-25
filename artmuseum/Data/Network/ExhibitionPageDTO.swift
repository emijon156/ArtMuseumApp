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
