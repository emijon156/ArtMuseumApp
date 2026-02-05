//
//  ExhibitionDetailViewModel.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import Foundation
import Combine

/// ViewModel for the exhibition detail screen.
/// Manages the state and business logic for displaying artworks within an exhibition.
/// Follows MVVM pattern - communicates with the domain layer via use cases.
@MainActor
class ExhibitionDetailViewModel: ObservableObject {
    
    /// Published list of artworks that triggers UI updates when changed
    @Published var artworks: [Artwork] = []
    
    /// Published loading state indicator
    @Published var isLoading = false
    
    /// Published error message for displaying API failures to the user
    @Published var errorMessage: String? = nil
    
    private let viewExhibitionDetailUseCase: ViewExhibitionDetailUseCase
    
    /// Initializes the ViewModel with dependency injection of the use case
    /// - Parameter useCase: The use case for fetching exhibition artworks
    init(useCase: ViewExhibitionDetailUseCase) {
        self.viewExhibitionDetailUseCase = useCase
    }
    
    /// Loads artworks for a specific exhibition from the data source
    /// - Parameter exhibitionID: The unique identifier of the exhibition
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