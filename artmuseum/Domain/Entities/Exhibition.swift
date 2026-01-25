//
//  Entities.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import Foundation

struct Exhibition: Identifiable, Equatable {
        let id: Int
        let title: String
        let description: String?
        let beginDate: String?
        let endDate: String?
        let imageUrl: URL?
        var artworks: [Artwork] = []
    }

