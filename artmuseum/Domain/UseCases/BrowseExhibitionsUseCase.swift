//
//  BrowseExhibitionsUseCase.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import Foundation

/// Use case protocol for browsing exhibitions.
/// Use cases encapsulate business logic and orchestrate data flow between
/// repositories and the presentation layer.
protocol BrowseExhibitionsUseCase {
    /// Executes the use case to retrieve all exhibitions
    /// - Returns: Array of Exhibition entities
    /// - Throws: Error if the operation fails
    func execute() async throws -> [Exhibition]
}

/// Default implementation of BrowseExhibitionsUseCase.
/// This acts as an intermediary between the presentation layer and the data layer,
/// following the Single Responsibility Principle.
final class DefaultBrowseExhibitionsUseCase: BrowseExhibitionsUseCase {
    private let repository: ExhibitionsRepository

    init(repository: ExhibitionsRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Exhibition] {
        return try await repository.fetchExhibitions()
    }
}