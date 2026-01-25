//
//  ArtworkDetailView.swift
//  artmuseum
//
//  Created by Emily Jon on 1/25/26.
//


import SwiftUI

struct ArtworkDetailView: View {
    let artwork: Artwork
    @ObservedObject var favoritesManager = FavoritesManager.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                //Image
                AsyncImage(url: artwork.imageUrl) { phase in
                    if let image = phase.image {
                        image.resizable().aspectRatio(contentMode: .fit)
                    } else if phase.error != nil {
                        Color.gray.opacity(0.3).frame(height: 300)
                    } else {
                        Color.gray.opacity(0.1).frame(height: 300)
                    }
                }
                .cornerRadius(0) // Full width look
                
                VStack(alignment: .leading, spacing: 16) {
                    //itle & Action Buttons
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(artwork.title)
                                .font(.title2)
                                .bold()
                            Text(artwork.artist ?? "Unknown")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Favorite Button
                        Button {
                            favoritesManager.toggle(artwork)
                        } label: {
                            Image(systemName: favoritesManager.contains(artwork) ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(favoritesManager.contains(artwork) ? .red : .gray)
                        }
                    }
                    
                    Divider()
                    
                    // Information
                    InfoRow(label: "Date", value: artwork.date)
                    InfoRow(label: "Medium", value: artwork.medium)
                    InfoRow(label: "Department", value: artwork.department)
                    InfoRow(label: "Credit", value: artwork.creditLine)
                    
                    //Share Button
                    if let url = artwork.imageUrl {
                        ShareLink(item: url, message: Text("Check out '\(artwork.title)' by \(artwork.artist ?? "")")) {
                            Label("Share Artwork", systemImage: "square.and.arrow.up")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoRow: View {
    let label: String
    let value: String?
    
    var body: some View {
        if let value = value, !value.isEmpty {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Text(value)
                    .font(.body)
            }
            .padding(.bottom, 4)
        }
    }
}
