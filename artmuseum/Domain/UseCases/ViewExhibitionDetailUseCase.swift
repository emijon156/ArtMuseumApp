//
//  ViewExhibitionDetailUseCase.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import Foundation

/// Use case protocol for viewing exhibition details, specifically fetching artworks.
/// Use cases encapsulate business logic and orchestrate data flow between
/// repositories and the presentation layer.
protocol ViewExhibitionDetailUseCase {
    /// Executes the use case to retrieve artworks for a specific exhibition
    /// - Parameter exhibitionID: The unique identifier of the exhibition
    /// - Returns: Array of Artwork entities associated with the exhibition
    /// - Throws: Error if the operation fails
    func execute(exhibitionID: Int) async throws -> [Artwork]
}

/// Default implementation of ViewExhibitionDetailUseCase.
/// This acts as an intermediary between the presentation layer and the data layer,
/// following the Single Responsibility Principle.
final class DefaultViewExhibitionDetailUseCase: ViewExhibitionDetailUseCase {
    private let repository: ArtworksRepository

    init(repository: ArtworksRepository) {
        self.repository = repository
    }

    func execute(exhibitionID: Int) async throws -> [Artwork] {
        return try await repository.fetchArtworks(exhibitionID: exhibitionID)
    }
}