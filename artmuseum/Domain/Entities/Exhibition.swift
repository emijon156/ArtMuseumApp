//
//  Exhibition.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import Foundation

/// Domain entity representing a museum exhibition.
/// This is a business entity independent of any external data sources.
struct Exhibition: Identifiable, Equatable {
    /// Unique identifier for the exhibition
    let id: Int
    
    /// Title of the exhibition
    let title: String
    
    /// Detailed description of the exhibition
    let description: String?
    
    /// Start date of the exhibition (ISO format: yyyy-MM-dd)
    let beginDate: String?
    
    /// End date of the exhibition (ISO format: yyyy-MM-dd)
    let endDate: String?
    
    /// URL to the primary image representing the exhibition
    let imageUrl: URL?
    
    /// Collection of artworks featured in this exhibition
    var artworks: [Artwork] = []
}

