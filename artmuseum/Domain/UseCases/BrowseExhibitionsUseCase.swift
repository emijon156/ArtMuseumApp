//
//  BrowseExhibitionsUseCase.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//


import Foundation

protocol BrowseExhibitionsUseCase {
    func execute() async throws -> [Exhibition]
}

final class DefaultBrowseExhibitionsUseCase: BrowseExhibitionsUseCase {
    private let repository: ExhibitionsRepository

    init(repository: ExhibitionsRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Exhibition] {
        return try await repository.fetchExhibitions()
    }
}