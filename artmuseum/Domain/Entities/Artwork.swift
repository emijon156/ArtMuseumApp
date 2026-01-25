//
//  Artwork.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//


import Foundation

struct Artwork: Identifiable, Equatable, Codable {
    let id: Int
    let title: String
    let artist: String?
    let imageUrl: URL?
    
    let date: String?
    let medium: String?
    let department: String?
    let creditLine: String?
}
