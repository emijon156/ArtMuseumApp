//
//  ExhibitionListViewModel.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//


import Foundation
import Combine

@MainActor
class ExhibitionListViewModel: ObservableObject {
    
    @Published var exhibitions: [Exhibition] = []
    @Published var errorMessage: String? = nil
    
    private let browseExhibitionsUseCase: BrowseExhibitionsUseCase
    
    // Dependency Injection
    init(useCase: BrowseExhibitionsUseCase) {
        self.browseExhibitionsUseCase = useCase
    }
    
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
