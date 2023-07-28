//
//  ContentView.swift
//  The Divine Names
//
//  Created by Reya Dawlah on 6/4/23.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.teal)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct DynamicStack<Content: View>: View {
    var horizontalAlignment = HorizontalAlignment.center
var verticalAlignment = VerticalAlignment.center
var spacing: CGFloat?
    @ViewBuilder var content: () -> Content

    var body: some View {
        GeometryReader { proxy in
            Group {
                if proxy.size.width > proxy.size.height {
                    HStack(
                        alignment: verticalAlignment,
                        spacing: spacing,
                        content: content
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else {
                    VStack(
                        alignment: horizontalAlignment,
                        spacing: spacing,
                        content: content
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                }
            }
        }
    }
}

struct CardView: View {
    private var numImages = 99
    @State private var flip = false
    @State private var flipText = "Show details"
    @State private var sound = false
    @State private var soundText = "Play sound"
    var body: some View {
        //scrollViewNames()
        NavigationView {
            TabView {
                ForEach(1..<numImages){ num in
                    DynamicStack{
                        Image("\(num)")
                            .resizable()
                            .scaledToFit()
                            .tag(num)
                            .padding()
                            .id(num)
                        VStack{
                            Button(self.flipText){
                                flip.toggle()
                                if flip{
                                    self.flipText = "Hide"
                                }
                                else{
                                    self.flipText = "Show details"
                                }
                            }
                            .buttonStyle(GrowingButton())
                                
                            Text("(Swipe left for the next name)")
                            .padding()
                            .italic()
                        }
                        
                        if flip {
                            Image("\(num)_back")
                                .resizable()
                                .scaledToFit()
                                .tag(num)
                                .padding()
                            
                        }
                        if sound {
                            
                        }
                        
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .padding()
        }
    }
}
struct ContentView: View {
    var body: some View {
        TabView{
            CardView()
                .tabItem{
                    Label("Cards", systemImage: "menucard.fill")
                }
            
            Scroll_Names()
                .tabItem{
                    Label("List", systemImage: "list.triangle")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
