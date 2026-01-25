//
//  ExhibitionsRepository.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//


import Foundation

protocol ExhibitionsRepository {
    // Returns a generic result with our Domain Entity
    func fetchExhibitions() async throws -> [Exhibition]
}