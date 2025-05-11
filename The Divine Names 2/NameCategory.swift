//
//  NameCategory.swift
//  The Divine Names 2
//
//  Created by Reya Dawlah on 4/13/25.
//

import SwiftUI

// MARK: - Category Model
struct NameCategory: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let color: Color
    let names: [String] // Indices of names in this category
    
    // You can add a description field if you want to show explanation of categories
    let description: String
    
    // Custom Equatable implementation since UUID isn't Equatable by default
    static func == (lhs: NameCategory, rhs: NameCategory) -> Bool {
        return lhs.id.uuidString == rhs.id.uuidString
    }
}

// Extension to your existing DataProvider to include categories
extension DataProvider {
    static let categories: [NameCategory] = [
        NameCategory(
            name: "Mercy",
            color: Color(red: 0.93, green: 0.72, blue: 0.72), // Pink
            names: ["Ar Rahmaan", "Ar Raheem", "Al Ghaffaar", "At Tawwaab", "Al Ghafoor", "Al 'Afuww", "Ar Raoof", "Al Wadood", "Al Kareem", "Al Barr"],
            description: "Names related to Allah's mercy and forgiveness"
        ),
        NameCategory(
            name: "Majesty",
            color: Color(red: 0.93, green: 0.82, blue: 0.72), // Beige
            names: ["Al Malik", "Al 'Azeez", "Al Mutakabbir", "Al Waasi'", "Al Kabeer", "Al 'Azeem", "Al Majeed", "Al Qawiyy", "Maalik ul Mulk", "Dhul Jalaali wal Ikraam", "Al Jabbaar", "Al Mateen", "Al Qaadir", "Al Muqtadir", "Al Qahhaar", "Al Jaleel", "Al Hameed", "'Aliyy", "Al Muhyee", "Al Mumeet", "Al Maajid", "Al Muqaddim", "Al Muakhkhir", "Al Muta'aali", "Al Jaami'", "Al Ghaniyy", "Al Maani'"],
            description: "Names depicting Allah's majesty and sovereignty"
        ),
        NameCategory(
            name: "Wisdom",
            color: Color(red: 0.93, green: 0.93, blue: 0.72), // Light yellow
            names: ["Al Hakeem", "Al 'Aleem", "Al Khabeer", "As Samee'", "Al Baseer", "Ash Shaheed", "Al Hakam", "Al 'Adl", "Al Waajid", "An Noor"],
            description: "Names related to Allah's wisdom and knowledge"
        ),
        NameCategory(
            name: "Benevolence",
            color: Color(red: 0.82, green: 0.93, blue: 0.72), // Light green
            names: ["Ar Razzaaq", "Al Wahhaab", "Al Fattaah", "Al Haleem", "Ash Shakoor", "Al Muqeet", "Al Mujeeb", "As Saboor", "Al Lateef", "Al Baasit", "Ar Raafi'", "Al Mu'izz", "Al Mughniyy"],
            description: "Names related to Allah's giving and provision"
        ),
        NameCategory(
            name: "Support",
            color: Color(red: 0.72, green: 0.93, blue: 0.82), // Mint
            names: ["Al Waali", "Al Mu'min", "Al Muhaymin", "Al Hafeez", "Ar Raqeeb", "Al Wakeel", "Al Waliyy", "As Samad", "An Naafi'", "Ar Rasheed", "Al Haadi"],
            description: "Names related to Allah's support and protection"
        ),
        NameCategory(
            name: "Creation",
            color: Color(red: 0.72, green: 0.82, blue: 0.93), // Light blue
            names: ["Al Khaaliq", "Al Baari'", "Al Musawwir", "Al Mubdee", "Al Mu'eed", "Al Badee'"],
            description: "Names related to Allah's creation and design"
        ),
        NameCategory(
            name: "Accountability",
            color: Color(red: 0.82, green: 0.72, blue: 0.93), // Light purple
            names: ["Al Muhsee", "Al Muqsit", "Ad Dhaar", "Al Khaafid", "Al Haseeb", "Al Muntaqim", "Al Baa'ith", "Al Mudhill", "Al Qaabid"],
            description: "Names related to Allah's judgment and justice"
        ),
        NameCategory(
            name: "Existence",
            color: Color(red: 0.93, green: 0.93, blue: 0.93), // White
            names: ["Al Awwal", "Al Aakhir", "Al Baaqi", "Al Hayy", "Al Qayyoom", "Al Waahid", "Al Ahad", "Al Waarith", "Al Baatin", "Adh Dhaahir", "Al Awwal", "Al Aakhir", "Al Quddoos", "Al Haqq"],
            description: "Names related to Allah's existence and eternal nature"
        )
    ]
    
    // Function to get the category for a name
    static func getCategory(for name: String) -> NameCategory? {
        for category in categories {
            if category.names.contains(name) {
                return category
            }
        }
        return nil
    }
    
    // Function to get all names in a category
    static func getNames(for category: NameCategory) -> [String] {
        return category.names
    }
    
    // Function to get all indices of names in a category
    static func getIndices(for category: NameCategory) -> [Int] {
        var indices: [Int] = []
        
        for name in category.names {
            if let index = names.firstIndex(of: name) {
                indices.append(index)
            }
        }
        
        return indices
    }
}
