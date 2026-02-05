//
//  Artwork.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import Foundation

/// Domain entity representing an artwork from the Harvard Art Museums collection.
/// This is a business entity independent of any external data sources.
struct Artwork: Identifiable, Equatable, Codable {
    /// Unique identifier for the artwork
    let id: Int
    
    /// Title of the artwork
    let title: String
    
    /// Name of the artist who created the artwork (may be unknown)
    let artist: String?
    
    /// URL to the primary image of the artwork
    let imageUrl: URL?
    
    /// Date or period when the artwork was created
    let date: String?
    
    /// Medium/materials used in the artwork (e.g., "Oil on canvas")
    let medium: String?
    
    /// Museum department housing the artwork
    let department: String?
    
    /// Credit line describing how the artwork was acquired
    let creditLine: String?
}
