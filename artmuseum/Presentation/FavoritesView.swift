//
//  FavoritesView.swift
//  artmuseum
//
//  Created by Emily Jon on 1/25/26.
//


import SwiftUI

struct FavoritesView: View {
    // Listen to the global manager
    @ObservedObject var manager = FavoritesManager.shared
    
    var body: some View {
        NavigationView {
            Group {
                if manager.savedArtworks.isEmpty {
                    // Modern Empty State
                    ContentUnavailableView(
                        "No Favorites",
                        systemImage: "heart.slash",
                        description: Text("Artworks you save will appear here.")
                    )
                } else {
                    ScrollView {
                        // Using LazyVStack to match Exhibition Detail style
                        LazyVStack(spacing: 20) {
                            ForEach(manager.savedArtworks) { artwork in
                                
                                //Click to Navigate
                                NavigationLink {
                                    ArtworkDetailView(artwork: artwork)
                                } label: {
                                    
                                    //The Row Layout
                                    HStack(alignment: .top, spacing: 16) {
                                        
                                        //Image with Heart Overlay
                                        ZStack(alignment: .topTrailing) {
                                            AsyncImage(url: artwork.imageUrl) { img in
                                                img.resizable()
                                                   .aspectRatio(contentMode: .fill)
                                            } placeholder: {
                                                Color.gray.opacity(0.3)
                                            }
                                            .frame(width: 140, height: 90) // Rectangular styling
                                            .cornerRadius(8)
                                            .clipped()
                                            
                                            // Heart Button
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
                                        
                                        //Text Info
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(artwork.title)
                                                .font(.headline)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                                .foregroundColor(.primary) // Ensure text isn't blue link color
                                            
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
                                    .contentShape(Rectangle()) // Ensures the whitespace is clickable
                                }
                                .buttonStyle(PlainButtonStyle()) // Removes default navigation link styling
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
