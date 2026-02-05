//
//  ExhibitionDetailView.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import SwiftUI

/// Detail view for displaying a specific exhibition and its associated artworks.
/// Features:
/// - Large exhibition image header
/// - Exhibition title, date range, and expandable description
/// - Searchable list of artworks in the exhibition
/// - Ability to favorite artworks directly from the list
struct ExhibitionDetailView: View {
    let exhibition: Exhibition
    
    @StateObject private var viewModel: ExhibitionDetailViewModel
    @ObservedObject var favoritesManager = FavoritesManager.shared
    
    @State private var searchText = ""
    @State private var isExpanded: Bool = false
    
    /// Character limit before truncating description with "Read more" option
    private let truncationLimit = 180
    
    /// Computed property that filters artworks based on search text
    var filteredArtworks: [Artwork] {
        if searchText.isEmpty {
            return viewModel.artworks
        } else {
            return viewModel.artworks.filter { artwork in
                artwork.title.localizedCaseInsensitiveContains(searchText) ||
                (artwork.artist?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    /// Initializes the view with an exhibition, setting up required dependencies
    init(exhibition: Exhibition) {
        self.exhibition = exhibition
        let repo = DefaultArtworksRepository()
        let useCase = DefaultViewExhibitionDetailUseCase(repository: repo)
        _viewModel = StateObject(wrappedValue: ExhibitionDetailViewModel(useCase: useCase))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Search bar fixed at top
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search inside exhibition...", text: $searchText)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding()
            .background(Color(UIColor.systemBackground))
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // Exhibition header image
                    AsyncImage(url: exhibition.imageUrl) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .overlay(Image(systemName: "photo").font(.largeTitle).foregroundColor(.gray))
                        }
                    }
                    .frame(height: 300)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Exhibition title and date
                        VStack(alignment: .leading, spacing: 8) {
                            Text(exhibition.title)
                                .font(.title)
                                .bold()
                            
                            Text(formattedDateRange())
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        // Exhibition description with expand/collapse
                        VStack(alignment: .leading, spacing: 6) {
                            Text(descriptionText)
                                .font(.body)
                                .animation(.easeInOut, value: isExpanded)
                            
                            if shouldShowReadMoreButton {
                                Button(action: { withAnimation { isExpanded.toggle() } }) {
                                    Text(isExpanded ? "Read less" : "Read more")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        
                        Divider().padding(.vertical, 8)
                        
                        // Artworks list with loading and empty states
                        if viewModel.isLoading {
                            ProgressView().frame(maxWidth: .infinity, minHeight: 100)
                        } else if filteredArtworks.isEmpty {
                            Text("No artworks found.")
                                .foregroundColor(.secondary)
                                .padding(.top, 20)
                        } else {
                            LazyVStack(spacing: 20) {
                                ForEach(filteredArtworks) { artwork in
                                    NavigationLink {
                                        ArtworkDetailView(artwork: artwork)
                                    } label: {
                                        // Artwork row with thumbnail and favorite button
                                        HStack(alignment: .top, spacing: 16) {
                                            
                                            ZStack(alignment: .topTrailing) {
                                                AsyncImage(url: artwork.imageUrl) { img in
                                                    img.resizable()
                                                       .aspectRatio(contentMode: .fill)
                                                } placeholder: {
                                                    Color.gray.opacity(0.3)
                                                }
                                                
                                                .frame(width: 140, height: 90)
                                                .cornerRadius(8)
                                                .clipped()
                                                
                                                // Favorite button overlay
                                                Button {
                                                    favoritesManager.toggle(artwork)
                                                } label: {
                                                    Image(systemName: favoritesManager.contains(artwork) ? "heart.fill" : "heart")
                                                        .foregroundColor(favoritesManager.contains(artwork) ? .red : .white)
                                                        .padding(6)
                                                        .background(Color.black.opacity(0.3))
                                                        .clipShape(Circle())
                                                }
                                                .padding(4)
                                            }
                                            
                                            // Artwork info
                                            VStack(alignment: .leading, spacing: 6) {
                                                Text(artwork.title)
                                                    .font(.headline)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.leading)
                                                
                                                Text(artwork.artist ?? "Unknown Artist")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                    .lineLimit(1)
                                                
                                                Text([artwork.medium, artwork.date].compactMap { $0 }.joined(separator: ", "))
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.leading)
                                                
                                                Spacer()
                                            }
                                            Spacer()
                                        }
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.bottom, 20)
                        }
                    }
                    .padding()
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadArtworks(exhibitionID: exhibition.id)
        }
    }
        
    /// Returns the description text, either truncated or full based on isExpanded state
    private var descriptionText: String {
        let fullDescription = exhibition.description ?? "No description available."
        if isExpanded || fullDescription.count <= truncationLimit {
            return fullDescription
        } else {
            let index = fullDescription.index(fullDescription.startIndex, offsetBy: truncationLimit)
            return String(fullDescription[..<index]) + "..."
        }
    }
    
    /// Determines if the "Read more" button should be shown
    private var shouldShowReadMoreButton: Bool {
        let fullDescription = exhibition.description ?? ""
        return fullDescription.count > truncationLimit
    }
    
    /// Formats the exhibition date range as "YYYY – YYYY"
    private func formattedDateRange() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy"
        
        var startYear = ""
        var endYear = ""
        
        if let start = exhibition.beginDate, let date = inputFormatter.date(from: start) {
            startYear = outputFormatter.string(from: date)
        }
        
        if let end = exhibition.endDate, let date = inputFormatter.date(from: end) {
            endYear = outputFormatter.string(from: date)
        }
        
        if !startYear.isEmpty && !endYear.isEmpty {
            return "\(startYear) – \(endYear)"
        } else {
            return startYear
        }
    }
}
