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
            if manager.savedArtworks.isEmpty {
                ContentUnavailableView("No Favorites", systemImage: "heart.slash", description: Text("Artworks you save will appear here."))
            } else {
                List(manager.savedArtworks) { artwork in
                    HStack {
                        AsyncImage(url: artwork.imageUrl) { img in
                            img.resizable().scaledToFill()
                        } placeholder: { Color.gray }
                        .frame(width: 60, height: 60).cornerRadius(4).clipped()
                        
                        VStack(alignment: .leading) {
                            Text(artwork.title).font(.headline)
                            Text(artwork.artist ?? "Unknown").font(.caption)
                        }
                    }
                }
                .navigationTitle("Favorites")
            }
        }
    }
}