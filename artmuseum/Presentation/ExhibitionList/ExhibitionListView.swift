//
//  ExhibitionListView.swift
//  artmuseum
//
//  Created by Emily Jon on 1/24/26.
//

import SwiftUI

struct ExhibitionListView: View {
    @StateObject var viewModel: ExhibitionListViewModel
    @State private var searchText = ""
    
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
                    NavigationLink {
                        ExhibitionDetailView(exhibition: exhibition)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    // Row Content
                    VStack(alignment: .leading, spacing: 12) {
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
    
    /// Formats a date range string for display in the UI.
    ///
    /// This function converts start and end dates from ISO 8601 format (yyyy-MM-dd) to a 
    /// more user-friendly abbreviated format (MMM d - MMM d). For example, "2024-01-15" 
    /// and "2024-02-28" would be formatted as "Jan 15 - Feb 28".
    ///
    /// - Parameters:
    ///   - start: Optional start date string in "yyyy-MM-dd" format
    ///   - end: Optional end date string in "yyyy-MM-dd" format
    ///
    /// - Returns: A formatted date range string, or an empty string if either date is nil
    ///            or if date parsing fails
    ///
    /// - Note: This function performs defensive date parsing. If the input strings don't match
    ///         the expected format or contain invalid dates, an empty string is returned rather
    ///         than crashing or showing malformed output.
    ///
    /// - Example:
    ///   ```swift
    ///   formatDateRange(start: "2024-01-15", end: "2024-02-28")
    ///   // Returns: "Jan 15 - Feb 28"
    ///   ```
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
