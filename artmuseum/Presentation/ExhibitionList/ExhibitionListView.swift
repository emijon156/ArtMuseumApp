//
//  ExhibitionListView.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import SwiftUI

/// Main view for browsing exhibitions from the Harvard Art Museums.
/// Displays a scrollable list of exhibitions with images, titles, dates, and descriptions.
/// Includes search functionality to filter exhibitions by title or description.
struct ExhibitionListView: View {
    @StateObject var viewModel: ExhibitionListViewModel
    @State private var searchText = ""
    
    /// Computed property that filters exhibitions based on search text
    var filteredExhibitions: [Exhibition] {
        if searchText.isEmpty {
            return viewModel.exhibitions
        } else {
            return viewModel.exhibitions.filter { exhibition in
                exhibition.title.localizedCaseInsensitiveContains(searchText) ||
                (exhibition.description?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredExhibitions) { exhibition in
                ZStack {
                    // Hidden NavigationLink for proper navigation behavior
                    NavigationLink {
                        ExhibitionDetailView(exhibition: exhibition)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    // Exhibition card content
                    VStack(alignment: .leading, spacing: 12) {
                        // Exhibition image
                        AsyncImage(url: exhibition.imageUrl) { phase in
                            if let image = phase.image {
                                image.resizable().aspectRatio(contentMode: .fill)
                            } else {
                                Color.gray.opacity(0.1)
                                    .overlay(Image(systemName: "photo").foregroundColor(.gray))
                            }
                        }
                        .frame(height: 220)
                        .cornerRadius(12)
                        .clipped()
                        
                        // Exhibition title and date range
                        HStack(alignment: .top) {
                            Text(exhibition.title)
                                .font(.headline)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text(formatDateRange(start: exhibition.beginDate, end: exhibition.endDate))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        // Exhibition description
                        if let description = exhibition.description {
                            Text(description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(3)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("Browse")
            .searchable(text: $searchText, prompt: "Search exhibitions")
            .task {
                await viewModel.loadExhibitions()
            }
        }
    }
    
    /// Formats exhibition date range from ISO format to user-friendly format
    /// - Parameters:
    ///   - start: Start date in yyyy-MM-dd format
    ///   - end: End date in yyyy-MM-dd format
    /// - Returns: Formatted date range string (e.g., "Jan 15 - Mar 30")
    private func formatDateRange(start: String?, end: String?) -> String {
        guard let start = start, let end = end else { return "" }
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d"
        if let startDate = inputFormatter.date(from: start),
           let endDate = inputFormatter.date(from: end) {
            return "\(outputFormatter.string(from: startDate)) - \(outputFormatter.string(from: endDate))"
        }
        return ""
    }
}
