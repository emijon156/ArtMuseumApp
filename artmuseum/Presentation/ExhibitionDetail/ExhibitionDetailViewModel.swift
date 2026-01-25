//
//  ExhibitionDetailViewModel.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//


import Foundation
import Combine

@MainActor
class ExhibitionDetailViewModel: ObservableObject {
    
    @Published var artworks: [Artwork] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let viewExhibitionDetailUseCase: ViewExhibitionDetailUseCase
    
    init(useCase: ViewExhibitionDetailUseCase) {
        self.viewExhibitionDetailUseCase = useCase
    }
    
    // We pass the ID in when we call load()
    func loadArtworks(exhibitionID: Int) async {
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let items = try await viewExhibitionDetailUseCase.execute(exhibitionID: exhibitionID)
            self.artworks = items
            self.isLoading = false
        } catch {
            self.errorMessage = "Failed to load art: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
}