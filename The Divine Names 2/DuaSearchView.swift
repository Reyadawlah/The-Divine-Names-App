//
//  Dua.swift
//  The Divine Names 2
//
//  Created by Reya Dawlah on 4/13/25.
//

import Foundation

import SwiftUI

// Dua Model
struct Dua: Codable, Identifiable {
    var id = UUID()
    var name: [String]
    var duaArabic: String
    var translation: String
    var source: String
    var keywords: [String]?
    var application: String?

    enum CodingKeys: String, CodingKey {
        case name
        case duaArabic = "dua_arabic"
        case translation
        case source
        case keywords
        case application
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let singleName = try? container.decode(String.self, forKey: .name) {
            name = [singleName]
        } else {
            name = try container.decode([String].self, forKey: .name)
        }
        duaArabic = try container.decode(String.self, forKey: .duaArabic)
        translation = try container.decode(String.self, forKey: .translation)
        source = try container.decode(String.self, forKey: .source)
        keywords = try? container.decode([String].self, forKey: .keywords)
        application = try? container.decode(String.self, forKey: .application)
    }
}

// DuaProvider
class DuaProvider: ObservableObject {
    @Published var duas: [Dua] = []

    init() {
        loadDuas()
    }

    func loadDuas() {
        guard let url = Bundle.main.url(forResource: "duas_with_99_names", withExtension: "json") else {
            print("JSON file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedDuas = try decoder.decode([Dua].self, from: data)
            DispatchQueue.main.async {
                self.duas = decodedDuas
            }
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
}

// Optimized Dua Search View (Updated with keyboard dismissal)
struct DuaSearchView: View {
    @StateObject private var duaProvider = DuaProvider()
    @State private var selectedQuality = ""
    @State private var duaSearchText = ""
    @State private var showingResults = false
    @State private var showCategoryPicker = true
    @FocusState private var isTextFieldFocused: Bool // Add FocusState
    
    var body: some View {
        VStack(spacing: 10) {
            // Collapsible header section
            VStack(spacing: 10) {
                HStack {
                    Text("Search Duas")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            showCategoryPicker.toggle()
                        }
                    }) {
                        Image(systemName: showCategoryPicker ? "chevron.up" : "chevron.down")
                            .padding(8)
                            .background(Color.teal.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                
                // Search bar (always visible)
                HStack {
                    TextField("Search by name", text: $duaSearchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .focused($isTextFieldFocused) // Apply focus binding
                    
                    Button(action: {
                        if !duaSearchText.isEmpty {
                            selectedQuality = ""
                            showingResults = true
                            isTextFieldFocused = false // Dismiss keyboard on search
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding(10)
                            .background(Color.teal)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(duaSearchText.isEmpty)
                }
                .padding(.horizontal)
                
                // Category section (collapsible)
                if showCategoryPicker {
                    Text("Filter by quality:")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 5)
                    
                    // Horizontal scrolling categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(DataProvider.duaQualities, id: \.self) { quality in
                                Button(action: {
                                    selectedQuality = quality
                                    duaSearchText = ""
                                    showingResults = true
                                    isTextFieldFocused = false // Dismiss keyboard on category selection
                                }) {
                                    Text(quality)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(
                                                    selectedQuality == quality
                                                    ? Color.teal.opacity(0.3)
                                                    : Color.teal.opacity(0.1)
                                                )
                                        )
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                    }
                }
            }
            .background(Color(.systemBackground))
            .compositingGroup()
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
            
            // Results area (takes remaining space)
            if showingResults {
                ZStack {
                    if getFilteredDuas().isEmpty {
                        VStack(spacing: 15) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                                .padding()
                            
                            Text("No duas found matching your criteria")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                        }
                        .onTapGesture {
                            isTextFieldFocused = false // Dismiss keyboard when tapping empty results
                        }
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 15) {
                                // Results header
                                if !selectedQuality.isEmpty {
                                    Text("Showing duas related to \"\(selectedQuality)\"")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal)
                                } else if !duaSearchText.isEmpty {
                                    Text("Showing duas matching \"\(duaSearchText)\"")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal)
                                }
                                
                                // Duas list
                                ForEach(getFilteredDuas()) { dua in
                                    DuaCard(dua: dua)
                                }
                            }
                            .padding(.vertical)
                        }
                        .onTapGesture {
                            isTextFieldFocused = false // Dismiss keyboard when tapping results
                        }
                    }
                }
            } else {
                // Empty state
                VStack(spacing: 15) {
                    Spacer()
                    
                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.teal.opacity(0.7))
                        .padding()
                    
                    Text("Select a quality or search by name to find appropriate duas")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .onTapGesture {
                    isTextFieldFocused = false // Dismiss keyboard when tapping empty state
                }
            }
        }
        .navigationTitle("Dua Search")
        .onChange(of: duaSearchText) { newValue in
            if !newValue.isEmpty {
                showingResults = true
                selectedQuality = ""
            }
        }
        // Add toolbar with keyboard dismissal button
        .toolbar {
            if isTextFieldFocused {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isTextFieldFocused = false
                    }
                }
            }
        }
        // Enable tapping anywhere on the screen to dismiss keyboard
        .contentShape(Rectangle())
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
    
    private func getFilteredDuas() -> [Dua] {
        if !selectedQuality.isEmpty {
            return duaProvider.duas.filter {
                $0.keywords?.contains(where: { $0.lowercased() == selectedQuality.lowercased() }) ?? false
            }
        } else if !duaSearchText.isEmpty {
            return duaProvider.duas.filter {
                $0.name.joined(separator: " ").lowercased().contains(duaSearchText.lowercased())
            }
        }
        return []
    }
}

// Dua Card component for cleaner code
struct DuaCard: View {
    let dua: Dua
    @State private var isExpanded = false
    @Environment(\.colorScheme) private var colorScheme // Add this to detect dark/light mode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name and expand button row
            HStack {
                Text(dua.name.joined(separator: ", "))
                    .font(.system(size: 24))
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.teal)
                        .padding(5)
                        .background(Color.teal.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            // Keywords as tags if expanded
            if isExpanded, let keywords = dua.keywords, !keywords.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(keywords, id: \.self) { keyword in
                            Text(keyword)
                                .font(.system(size: 18))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.teal.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                }
            }
            
            // Arabic text
            Text(dua.duaArabic)
                .font(.system(size: isExpanded ? 30 : 18))
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.vertical, 4)
                .lineLimit(isExpanded ? nil : 2)
                .lineSpacing(20) // You already added this
                .foregroundColor(.primary) // Add this for proper dark mode text
            
            // Translation
            Text(dua.translation)
                .font(.system(size: isExpanded ? 24 : 18))
                .foregroundColor(.primary)
                .padding(10)
                .background(Color(.systemGray6)) // Use system colors instead of fixed gray
                .cornerRadius(8)
                .lineLimit(isExpanded ? nil : 3)
            
            // Source and application if expanded
            if isExpanded {
                Divider()
                    .padding(.vertical, 4)
                
                Text("Source: \(dua.source)")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
                
                if let app = dua.application {
                    Text("When to recite: \(app)")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colorScheme == .dark ? Color(.systemGray6) : .white) // Adapt background to dark mode
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 3, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
}
