//
//  HomeView 2.swift
//  The Divine Names 2
//
//  Created by Reya Dawlah on 4/21/25.
//

// MARK: - Home View (New)
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var moonOffset: CGFloat = 0
    @State private var animating = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Bouncing Crescent Moon Animation
                ZStack {
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.teal)
                        .offset(y: moonOffset)
                        .onAppear {
                            withAnimation(
                                Animation.easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true)
                            ) {
                                self.moonOffset = -15
                                self.animating = true
                            }
                        }
                }
                .frame(height: 100)
                .padding(.top, 50)
                
                Text("Start Learning Here")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 75)
                
                VStack(spacing: 15) {
                    HomeButtonView(title: "See Names and Explanations", icon: "list.bullet") {
                        withAnimation {
                            viewModel.selectedTab = 2
                        }
                    }
                    
                    HomeButtonView(title: "Learn with Flashcards", icon: "square.stack.fill") {
                        withAnimation {
                            viewModel.selectedTab = 1
                        }
                    }
                    
                    HomeButtonView(title: "Learn duaa with the 99 Names", icon: "text.book.closed.fill") {
                        withAnimation {
                            viewModel.selectedTab = 4
                        }
                    }
                    
                    HomeButtonView(title: "Test Your Knowledge", icon: "questionmark.circle.fill") {
                        withAnimation {
                            viewModel.selectedTab = 3
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 0)
            }
            .padding()
        }
        .navigationTitle("99 Names of Allah")
    }

}

struct HomeButtonView: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 30)
                
                Text(title)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .padding()
            .background(Color.teal.opacity(0.2))
            .cornerRadius(10)
            .foregroundColor(.primary)
        }
    }
}
// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppViewModel())
    }
}
