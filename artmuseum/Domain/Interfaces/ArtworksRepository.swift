//
//  ArtworksRepository.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//


import Foundation

protocol ArtworksRepository {
    func fetchArtworks(exhibitionID: Int) async throws -> [Artwork]
    func searchArtworks(query: String) async throws -> [Artwork]
}
