//
//  CategoryCircle.swift
//  The Divine Names 2
//
//  Created by Reya Dawlah on 4/13/25.
//
import SwiftUI

// MARK: - Category Circle Component
struct CategoryCircle: View {
    let category: NameCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        VStack {
            Circle()
                .fill(category.color)
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.gray : Color.clear, lineWidth: 3)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                .onTapGesture {
                    action()
                }
            
            Text(category.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                // Apply the curved text effect similar to your design
                .rotationEffect(.degrees(-5))
                .offset(y: -5)
        }
    }
}

// MARK: - Preview
struct CategoryCircle_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 20) {
            CategoryCircle(
                category: NameCategory(
                    name: "Mercy", 
                    color: Color(red: 0.93, green: 0.72, blue: 0.72),
                    names: [],
                    description: ""
                ),
                isSelected: true,
                action: {}
            )
            
            CategoryCircle(
                category: NameCategory(
                    name: "Wisdom", 
                    color: Color(red: 0.93, green: 0.93, blue: 0.72),
                    names: [],
                    description: ""
                ),
                isSelected: false,
                action: {}
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
