//
//  ViewExhibitionDetailUseCase.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//


import Foundation

protocol ViewExhibitionDetailUseCase {
    func execute(exhibitionID: Int) async throws -> [Artwork]
}

final class DefaultViewExhibitionDetailUseCase: ViewExhibitionDetailUseCase {
    private let repository: ArtworksRepository

    init(repository: ArtworksRepository) {
        self.repository = repository
    }

    func execute(exhibitionID: Int) async throws -> [Artwork] {
        return try await repository.fetchArtworks(exhibitionID: exhibitionID)
    }
}