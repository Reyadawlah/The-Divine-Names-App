//
//  NameDetail.swift
//  The Divine Names 2
//
//  Created by Reya Dawlah on 4/16/25.
//


import SwiftUI

struct NameDetail: Codable, Identifiable {
    var id: Int { return number }
    let number: Int
    let name: String
    let meaning: String
    let appearances: String
    let arabicText: String
    let translation: String
    let quranReference: String
    let description: String
    let additionalInfo: String?
}

struct AllNames: Codable {
    let names: [NameDetail]
}

// Data provider for the 99 names
class DivineNamesDataProvider {
    static let shared = DivineNamesDataProvider()
    
    var allNames: [NameDetail] = []
    
    init() {
        loadNamesFromJSON()
    }
    
    func loadNamesFromJSON() {
        if let path = Bundle.main.path(forResource: "divine_names_json", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                let names = try decoder.decode(AllNames.self, from: data)
                self.allNames = names.names
                print("Successfully loaded \(allNames.count) names")
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("JSON file not found")
        }
    }
    
    func getNameDetail(for index: Int) -> NameDetail? {
        // Because indices in your DataProvider.names array start at 0,
        // but name numbers in the JSON start at 1
        return allNames.first(where: { $0.number == index + 1 })
    }
}

struct NameDetailView: View {
    let detail: NameDetail
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Name and meaning header
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(detail.number): \(detail.name)")
                        .font(.system(size: 28, weight: .bold))
                    
                    Text(detail.meaning)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 10)
                
                // Appearances
                if !detail.appearances.isEmpty {
                    sectionWithBullet(title: "Appears", content: detail.appearances)
                }
                
                // Quranic Context
                if !detail.arabicText.isEmpty {
                    sectionWithTitle(title: "In context:")
                    
                    Text(detail.arabicText)
                        .font(.custom("Avenir-Italic", size: 33))
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .lineSpacing(20)
                    
                    Text(detail.translation)
                        .font(.custom("Avenir-Italic", size: 20))
                        .padding(.horizontal)
                        .foregroundColor(.secondary)
                        .lineSpacing(15)
                    
                    Text(detail.quranReference)
                        .font(.custom("Avenir-Italic", size: 18))
                        .padding(.horizontal)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                // Description
                sectionWithTitle(title: "Description")
                Text(detail.description)
                    .font(.custom("Avenir-Book", size: 24))
                    .padding(.horizontal)
                
                // Additional Info (if available)
                if let additionalInfo = detail.additionalInfo, !additionalInfo.isEmpty {
                    sectionWithTitle(title: "Additional Information")
                    Text(additionalInfo)
                        .font(.custom("Avenir-Italic", size: 20))
                        .padding(.horizontal)
                        .foregroundColor(.secondary)
                        .lineSpacing(15)
                }
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("Description")
    }
    
    private func sectionWithTitle(title: String) -> some View {
        Text(title)
            .font(.system(size: 20, weight: .bold))
            .padding(.horizontal)
            .padding(.top, 10)
    }
    
    private func sectionWithBullet(title: String, content: String) -> some View {
        HStack(alignment: .top) {
            Text("•")
                .font(.system(size: 20))
                .padding(.trailing, 5)
            Text("\(title): \(content)")
                .font(.custom("Avenir-Book", size: 18))
        }
        .padding(.horizontal)
    }
}
