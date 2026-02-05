//
//  ExhibitionsRepository.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import Foundation

/// Repository protocol defining the interface for fetching exhibition data.
/// This follows the Dependency Inversion Principle - the Domain layer defines
/// the interface while the Data layer provides the implementation.
protocol ExhibitionsRepository {
    /// Fetches a list of exhibitions from the data source
    /// - Returns: Array of Exhibition domain entities
    /// - Throws: Error if the fetch operation fails
    func fetchExhibitions() async throws -> [Exhibition]
}