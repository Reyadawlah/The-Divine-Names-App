//
//  Scroll.swift
//  The Divine Names 2
//
//  Created by Reya Dawlah on 4/13/25.
//

import SwiftUI
import AVFoundation

// MARK: - List View (Enhanced with Categories)
struct Scroll_Names: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State var scrollNum = ""
    @State var scrollToIndex : Int = 0
    @State private var isTimerRunning = false
    @State private var timer: Timer?
    @State private var scrollViewProxy: ScrollViewProxy?
    @State private var currentIndex = 0
    @State private var isScrolling = false
    @State private var showDetailView : Bool = false
    @State private var selectedCategory: NameCategory?
    @State private var showCategoryDescription = false
    
    @State private var player: AVAudioPlayer?
    // Add these variables to track audio position
    @State private var audioPosition: TimeInterval = 0
    @State private var isAudioPaused = false
    
    // Add FocusState for keyboard management
    @FocusState private var isTextFieldFocused: Bool
    
    // Break complex computed properties into simpler functions
    private func getFilteredNames() -> [String] {
        if let category = selectedCategory {
            return DataProvider.getNames(for: category)
        } else {
            return DataProvider.names
        }
    }
    
    private func getFilteredIndices() -> [Int] {
        if let category = selectedCategory {
            return DataProvider.getIndices(for: category)
        } else {
            return Array(0..<DataProvider.names.count)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                // Category circles menu
                categoryMenu
                
                // Category description if showing
                categoryDescriptionView
                
                // Search bar
                searchBarView
                
                // Names list
                namesListView
                
                // Control buttons
                buttonControls
            }
            .navigationTitle("99 Names of Allah")
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
            // Allow tapping anywhere to dismiss keyboard
            .onTapGesture {
                isTextFieldFocused = false
            }
        }
    }
    
    // MARK: - Extracted Views to simplify the main body
    
    private var categoryMenu: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                // "All" option
                VStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(selectedCategory == nil ? Color.gray : Color.clear, lineWidth: 3)
                        )
                        .onTapGesture {
                            selectedCategory = nil
                            isTextFieldFocused = false // Dismiss keyboard when changing category
                        }
                    
                    Text("All")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                // Category circles
                ForEach(DataProvider.categories) { category in
                    VStack {
                        Circle()
                            .fill(category.color)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Circle()
                                    .stroke(selectedCategory?.id == category.id ? Color.gray : Color.clear, lineWidth: 3)
                            )
                            .onTapGesture {
                                selectedCategory = category
                                showCategoryDescription = true
                                isTextFieldFocused = false // Dismiss keyboard when changing category
                            }
                        
                        Text(category.name)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 10)
    }
    
    private var categoryDescriptionView: some View {
        Group {
            if showCategoryDescription, let category = selectedCategory {
                VStack {
                    Text(category.description)
                        .font(.system(size: 16))
                        .padding()
                        .background(category.color.opacity(0.3))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .transition(.opacity)
                .animation(.easeInOut, value: showCategoryDescription)
                .onTapGesture {
                    isTextFieldFocused = false // Dismiss keyboard when tapping description
                }
            }
        }
    }
    
    private var searchBarView: some View {
        VStack {
            TextField("Enter a number to scroll: ", text: $scrollNum)
                .frame(height: 55)
                .border(Color.gray)
                .padding(.horizontal)
                .keyboardType(.numberPad)
                .focused($isTextFieldFocused) // Add focus binding
            
            Button("Jump to Name"){
                withAnimation(.spring()){
                    if let index = Int(scrollNum){
                        scrollToIndex = index-1
                    }
                }
                isTextFieldFocused = false // Dismiss keyboard after jumping
            }
            .font(.system(size: 20))
            .italic()
        }
    }
    
    private var namesListView: some View {
        ScrollView(){
            ScrollViewReader { proxy in
                LazyVStack {
                    ForEach(getFilteredIndices(), id: \.self) { index in
                        nameItemView(for: index)
                    }
                }
                .onChange(of: scrollToIndex, perform: { value in
                    proxy.scrollTo(value, anchor: .top)
                })
                .onChange(of: selectedCategory) { [oldCategory = selectedCategory] newCategory in
                    // Reset scroll position when category changes
                    if oldCategory != newCategory, let firstIndex = getFilteredIndices().first {
                        scrollToIndex = firstIndex + 1
                    }
                }
                .overlay(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            scrollViewProxy = proxy
                        }
                        .onChange(of: isScrolling) { newValue in
                            if newValue {
                                startScrolling()
                            } else {
                                stopScrolling()
                            }
                        }
                        .frame(width: 0, height: 0)
                })
                .onTapGesture {
                    isTextFieldFocused = false // Dismiss keyboard when tapping on the list
                }
            }
        }
    }
    
    private func nameItemView(for index: Int) -> some View {
        // Create the common UI for the list item
        let listItemView = Text("\(index+1). \(DataProvider.names[index])")
            .font(.custom("Avenir-Book", fixedSize: 25))
            .padding()
            .frame(maxWidth: 350, maxHeight: 300)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(getCategoryColor(for: DataProvider.names[index]))
            )
            .foregroundColor(.primary)
            .cornerRadius(15)
            .id(index + 1)
        
        // Get the name detail for this index
        let nameDetail = DivineNamesDataProvider.shared.getNameDetail(for: index)
        
        // Create the navigation link with appropriate destination
        return NavigationLink {
            if let detail = nameDetail {
                NameDetailView(detail: detail)
            } else {
                Text("Details not available for this name")
            }
        } label: {
            listItemView
        }
        .simultaneousGesture(TapGesture().onEnded {
            // Ensure keyboard is dismissed when tapping a name item
            isTextFieldFocused = false
        })
    }
    
    private var buttonControls: some View {
        HStack {
            Button(action: {
                if isScrolling {
                    // If currently scrolling, stop both scrolling and audio
                    isScrolling = false
                    stopSound()
                } else {
                    // If not scrolling, start both scrolling and audio
                    isScrolling = true
                    playSound()
                }
                isTextFieldFocused = false // Dismiss keyboard when using controls
            }) {
                Text(isScrolling ? "Stop" : "Start")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.teal)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button(action: {
                scrollToTop()
                isTextFieldFocused = false // Dismiss keyboard when using controls
            }) {
                Text("Scroll to Top")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.teal)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            // New button to reset everything
            Button(action: {
                resetAudioAndScroll()
                isTextFieldFocused = false // Dismiss keyboard when using controls
            }) {
                Text("Reset")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.teal)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
    }
    func resetAudioAndScroll() {
        // Stop current audio if playing
        if isScrolling {
            isScrolling = false
        }
        player?.stop()
        
        // Reset audio position
        audioPosition = 0
        isAudioPaused = false
        
        // Reset player
        if let url = Bundle.main.url(forResource: "100 names pcess 1", withExtension: "mp3") {
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: url)
                player = audioPlayer
            } catch {
                print("\(error)")
            }
        }
        
        // Scroll to top
        scrollToTop()
    }
    // MARK: - Helper Functions
    
    // Function to get color for a name based on its category
    private func getCategoryColor(for name: String) -> Color {
        if let category = DataProvider.getCategory(for: name) {
            return category.color.opacity(0.2)
        }
        return Color.teal.opacity(0.2) // Default color for uncategorized names
    }
    
    func startScrolling() {
        guard timer == nil, let proxy = scrollViewProxy else {
            return
        }
        
        let indices = getFilteredIndices()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            withAnimation {
                if !indices.isEmpty {
                    let nextIndex = (indices.firstIndex(of: currentIndex) ?? -1) + 1
                    if nextIndex < indices.count {
                        currentIndex = indices[nextIndex]
                    } else {
                        currentIndex = indices[0] // Loop back to the beginning
                    }
                    proxy.scrollTo(currentIndex, anchor: .top)
                }
            }
        }
    }
    
    func stopScrolling() {
        timer?.invalidate()
        timer = nil
        stopSound()
    }
    
    func scrollToTop() {
        withAnimation {
            let indices = getFilteredIndices()
            if let firstIndex = indices.first {
                currentIndex = firstIndex
                scrollViewProxy?.scrollTo(firstIndex, anchor: .top)
            }
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "100 names pcess 1", withExtension: "mp3") else {
            return
        }
        
        do {
            // If we already have a player instance and it's just paused
            if let existingPlayer = player, isAudioPaused {
                existingPlayer.currentTime = audioPosition
                existingPlayer.play()
                isAudioPaused = false
            } else {
                // Create a new player
                let audioPlayer = try AVAudioPlayer(contentsOf: url)
                player = audioPlayer
                
                // If we have a saved position, start from there
                if audioPosition > 0 {
                    player?.currentTime = audioPosition
                }
                
                player?.play()
            }
        } catch {
            print("\(error)")
        }
    }

    // Update the stopSound function
    func stopSound() {
        // Save the current position before stopping
        if let currentPlayer = player {
            audioPosition = currentPlayer.currentTime
            currentPlayer.pause()
            isAudioPaused = true
            // Don't set player to nil anymore, just pause it
        }
    }
}

// MARK: - Preview
struct Scroll_Names_Previews: PreviewProvider {
    static var previews: some View {
        Scroll_Names()
            .environmentObject(AppViewModel())
    }
}
