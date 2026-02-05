//
//  ExhibitionListViewModel.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import Foundation
import Combine

/// ViewModel for the exhibitions list screen.
/// Manages the state and business logic for displaying a list of exhibitions.
/// Follows MVVM pattern - communicates with the domain layer via use cases.
@MainActor
class ExhibitionListViewModel: ObservableObject {
    
    /// Published list of exhibitions that triggers UI updates when changed
    @Published var exhibitions: [Exhibition] = []
    
    /// Published error message for displaying API failures to the user
    @Published var errorMessage: String? = nil
    
    private let browseExhibitionsUseCase: BrowseExhibitionsUseCase
    
    /// Initializes the ViewModel with dependency injection of the use case
    /// - Parameter useCase: The use case for fetching exhibitions
    init(useCase: BrowseExhibitionsUseCase) {
        self.browseExhibitionsUseCase = useCase
    }
    
    /// Loads exhibitions from the data source via the use case
    /// Updates the published properties to reflect loading state and results
    func loadExhibitions() async {
        self.errorMessage = nil
        
        do {
            let items = try await browseExhibitionsUseCase.execute()
            self.exhibitions = items
        } catch {
            self.errorMessage = "Failed to load: \(error.localizedDescription)"
        }
    }
}
