//
//  FavoritesView.swift
//  artmuseum
//
//  Created by Emily Jon on 1/25/26.
//

import SwiftUI

/// View for displaying the user's saved favorite artworks.
/// Features:
/// - Empty state when no favorites are saved
/// - List of favorite artworks with thumbnails and metadata
/// - Direct navigation to artwork details
/// - Toggle favorite status (unfavorite) from this view
struct FavoritesView: View {
    /// Observes the shared favorites manager for reactive updates
    @ObservedObject var manager = FavoritesManager.shared
    
    var body: some View {
        NavigationView {
            Group {
                if manager.savedArtworks.isEmpty {
                    // Modern empty state view
                    ContentUnavailableView(
                        "No Favorites",
                        systemImage: "heart.slash",
                        description: Text("Artworks you save will appear here.")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(manager.savedArtworks) { artwork in
                                
                                // Navigable artwork row
                                NavigationLink {
                                    ArtworkDetailView(artwork: artwork)
                                } label: {
                                    
                                    // Artwork row layout
                                    HStack(alignment: .top, spacing: 16) {
                                        
                                        // Artwork thumbnail with unfavorite button
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
                                            
                                            // Unfavorite button
                                            Button {
                                                manager.toggle(artwork)
                                            } label: {
                                                Image(systemName: "heart.fill")
                                                    .foregroundColor(.red)
                                                    .padding(6)
                                                    .background(Color.black.opacity(0.3))
                                                    .clipShape(Circle())
                                            }
                                            .padding(4)
                                        }
                                        
                                        // Artwork metadata
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(artwork.title)
                                                .font(.headline)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                                .foregroundColor(.primary)
                                            
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
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
