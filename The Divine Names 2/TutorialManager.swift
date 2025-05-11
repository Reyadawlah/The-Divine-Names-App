//
//  TutorialManager.swift
//  The Divine Names 2
//
//  Created by Reya Dawlah on 4/30/25.
//


// MARK: - Tutorial System

// First, let's create a model to track the tutorial state
// For storing if the tutorial has been shown
// MARK: - Enhanced Tutorial Manager
import SwiftUI

// For tracking which views the user has seen tutorials for
class TutorialManager: ObservableObject {
    @Published var hasSeenTutorial: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenTutorial, forKey: "hasSeenTutorial")
        }
    }
    
    @Published var hasSeenCardTutorial: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenCardTutorial, forKey: "hasSeenCardTutorial")
        }
    }
    
    @Published var hasSeenQuizTutorial: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenQuizTutorial, forKey: "hasSeenQuizTutorial")
        }
    }
    
    @Published var hasSeenNamesTutorial: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenNamesTutorial, forKey: "hasSeenNamesTutorial")
        }
    }
    
    @Published var hasSeenDuaTutorial: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenDuaTutorial, forKey: "hasSeenDuaTutorial")
        }
    }
    
    @Published var currentTutorialStep: Int = 0
    @Published var showingTutorial: Bool = false
    @Published var currentViewForTutorial: Int = 0 // Matches the tab index
    
    init() {
        // Load the saved states
        self.hasSeenTutorial = UserDefaults.standard.bool(forKey: "hasSeenTutorial")
        self.hasSeenCardTutorial = UserDefaults.standard.bool(forKey: "hasSeenCardTutorial")
        self.hasSeenQuizTutorial = UserDefaults.standard.bool(forKey: "hasSeenQuizTutorial")
        self.hasSeenNamesTutorial = UserDefaults.standard.bool(forKey: "hasSeenNamesTutorial")
        self.hasSeenDuaTutorial = UserDefaults.standard.bool(forKey: "hasSeenDuaTutorial")
    }
    
    func startTutorial(for viewIndex: Int? = nil) {
        currentTutorialStep = 0
        showingTutorial = true
        
        if let viewIndex = viewIndex {
            currentViewForTutorial = viewIndex
        }
        
        // Mark the specific tutorial as seen
        switch currentViewForTutorial {
        case 0:
            hasSeenCardTutorial = true
        case 1:
            hasSeenQuizTutorial = true
        case 2:
            hasSeenNamesTutorial = true
        case 3:
            hasSeenDuaTutorial = true
        default:
            break
        }
    }
    
    func nextStep() {
        currentTutorialStep += 1
    }
    
    func endTutorial() {
        showingTutorial = false
        hasSeenTutorial = true  // Mark overall tutorial as seen
    }
    
    // Check if we should show a tutorial for a specific tab when switching to it
    func checkAndShowTutorialForTab(_ tabIndex: Int) {
        // Only show if the overall tutorial has been seen
        // but the specific tab tutorial hasn't
        if hasSeenTutorial {
            switch tabIndex {
            case 0 where !hasSeenCardTutorial:
                startTutorial(for: 0)
            case 1 where !hasSeenQuizTutorial:
                startTutorial(for: 1)
            case 2 where !hasSeenNamesTutorial:
                startTutorial(for: 2)
            case 3 where !hasSeenDuaTutorial:
                startTutorial(for: 3)
            default:
                break
            }
        }
    }
}

// Enhanced tutorial overlay with improved design
struct EnhancedTutorialOverlayView: View {
    @EnvironmentObject var tutorialManager: TutorialManager
    let steps: [TutorialStep]
    
    var currentStep: TutorialStep {
        steps[min(tutorialManager.currentTutorialStep, steps.count - 1)]
    }
    
    var body: some View {
        if tutorialManager.showingTutorial {
            ZStack {
                // Semi-transparent background
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // Allow tapping anywhere to advance
                        if tutorialManager.currentTutorialStep < steps.count - 1 {
                            tutorialManager.nextStep()
                        } else {
                            tutorialManager.endTutorial()
                        }
                    }
                
                // Progress indicator
                HStack(spacing: 8) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        Circle()
                            .fill(index <= tutorialManager.currentTutorialStep ? Color.white : Color.gray.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(10)
                .background(Color.black.opacity(0.6))
                .cornerRadius(20)
                .padding(.top, 40)
                .frame(maxHeight: .infinity, alignment: .top)
                
                // Tooltip
                VStack(spacing: 20) {
                    Text(currentStep.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(currentStep.description)
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    HStack(spacing: 20) {
                        // Skip button (only show if not on the last step)
                        if tutorialManager.currentTutorialStep < steps.count - 1 {
                            Button(action: {
                                tutorialManager.endTutorial()
                            }) {
                                Text("Skip All")
                                    .fontWeight(.medium)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.gray.opacity(0.5))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        
                        // Next/Got it button
                        Button(action: {
                            if tutorialManager.currentTutorialStep < steps.count - 1 {
                                tutorialManager.nextStep()
                            } else {
                                tutorialManager.endTutorial()
                            }
                        }) {
                            Text(currentStep.buttonText)
                                .fontWeight(.bold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .frame(minWidth: 120)
                                .background(Color.teal) // Match app's color scheme
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(UIColor.systemGray6).opacity(0.95))
                )
                .shadow(radius: 10)
                .padding(.horizontal, 30)
                .position(positionForStep(currentStep))
                
                // Highlight indicator for the specific UI element
                highlightForStep(currentStep)
            }
            .transition(.opacity)
            .animation(.easeInOut, value: tutorialManager.currentTutorialStep)
        }
    }
    
    // Helper to position the tooltip
    private func positionForStep(_ step: TutorialStep) -> CGPoint {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        switch step.position {
        case .top:
            return CGPoint(x: screenWidth / 2, y: screenHeight * 0.25)
        case .bottom:
            return CGPoint(x: screenWidth / 2, y: screenHeight * 0.75)
        case .left:
            return CGPoint(x: screenWidth * 0.25, y: screenHeight / 2)
        case .right:
            return CGPoint(x: screenWidth * 0.75, y: screenHeight / 2)
        case .center:
            return CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        }
    }
    
    // Helper to create a highlight effect for the current step
    @ViewBuilder
    private func highlightForStep(_ step: TutorialStep) -> some View {
        // This is a placeholder. In a real implementation, you would
        // use custom highlight shapes for each specific UI element
        // based on the step ID and view
        
        if step.id > 0 {
            Circle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: 100, height: 100)
                .position(highlightPositionForStep(step))
                .opacity(0.6)
                .allowsHitTesting(false)
        }
    }
    
    // Helper to position the highlight
    private func highlightPositionForStep(_ step: TutorialStep) -> CGPoint {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        // These positions would need to be customized for your specific UI
        switch tutorialManager.currentViewForTutorial {
        case 0: // HomeView
            switch step.id {
            case 1: // Home screen general
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.4)
            case 2: // Names and Explanations button
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.35)
            case 3: // Flashcards button
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.45)
            case 4: // Duas button
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.55)
            case 5: // Quiz button
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.65)
            default:
                return CGPoint(x: screenWidth / 2, y: screenHeight / 2)
            }
        case 1: // CardView
            switch step.id {
            case 1: // Show meaning button
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.8)
            case 2: // Navigation arrows
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.15)
            case 3: // Card counter
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.1)
            default:
                return CGPoint(x: screenWidth / 2, y: screenHeight / 2)
            }
            
        case 2: // QuizView
            switch step.id {
            case 1: // Answer options
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.5)
            case 2: // Results area
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.7)
            default:
                return CGPoint(x: screenWidth / 2, y: screenHeight / 2)
            }
            
        case 3: // Scroll_Names
            switch step.id {
            case 1: // Categories
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.15)
            case 2: // Jump to Name
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.25)
            case 3: // Controls
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.85)
            default:
                return CGPoint(x: screenWidth / 2, y: screenHeight / 2)
            }
            
        case 4: // DuaSearchView
            switch step.id {
            case 1: // Filter categories
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.2)
            case 2: // Search bar
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.15)
            case 3: // Dua card
                return CGPoint(x: screenWidth / 2, y: screenHeight * 0.5)
            default:
                return CGPoint(x: screenWidth / 2, y: screenHeight / 2)
            }
            
        default:
            return CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        }
    }
}
// A tutorial step model
struct TutorialStep {
    let id: Int
    let title: String
    let description: String
    let position: TutorialPosition
    let buttonText: String
}

// Position enum for where to show the tooltip
enum TutorialPosition {
    case top, bottom, left, right, center
}

// A highlighting overlay with tooltip
struct TutorialOverlayView: View {
    @EnvironmentObject var tutorialManager: TutorialManager
    let steps: [TutorialStep]
    
    var currentStep: TutorialStep {
        steps[min(tutorialManager.currentTutorialStep, steps.count - 1)]
    }
    
    var body: some View {
        if tutorialManager.showingTutorial {
            ZStack {
                // Semi-transparent background
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // Optional: Allow tapping anywhere to advance
                        if tutorialManager.currentTutorialStep < steps.count - 1 {
                            tutorialManager.nextStep()
                        } else {
                            tutorialManager.endTutorial()
                        }
                    }
                
                // Tooltip
                VStack(spacing: 20) {
                    Text(currentStep.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(currentStep.description)
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        if tutorialManager.currentTutorialStep < steps.count - 1 {
                            tutorialManager.nextStep()
                        } else {
                            tutorialManager.endTutorial()
                        }
                    }) {
                        Text(currentStep.buttonText)
                            .fontWeight(.bold)
                            .padding()
                            .frame(minWidth: 120)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray5))
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding(.horizontal, 20)
                .position(positionForStep(currentStep))
            }
        }
    }
    
    // Helper to position the tooltip
    private func positionForStep(_ step: TutorialStep) -> CGPoint {
        // You would customize these positions based on your UI layout
        // This is a simplified example
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        switch step.position {
        case .top:
            return CGPoint(x: screenWidth / 2, y: screenHeight * 0.25)
        case .bottom:
            return CGPoint(x: screenWidth / 2, y: screenHeight * 0.75)
        case .left:
            return CGPoint(x: screenWidth * 0.25, y: screenHeight / 2)
        case .right:
            return CGPoint(x: screenWidth * 0.75, y: screenHeight / 2)
        case .center:
            return CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        }
    }
}

// MARK: - Integration with App

// Add this to your AppViewModel
extension AppViewModel {
    func setupTutorial() {
        let tutorialManager = TutorialManager()
        if !tutorialManager.hasSeenTutorial {
            // Start tutorial on first launch
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                tutorialManager.startTutorial()
            }
        }
    }
}

// MARK: - HomeView Tutorial Implementation
extension HomeView {
    func tutorialSteps() -> [TutorialStep] {
        return [
            TutorialStep(
                id: 0,
                title: "Welcome to 99 Names of Allah",
                description: "This app will help you learn and understand the beautiful names of Allah through various interactive methods.",
                position: .center,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 1,
                title: "Home Screen Navigation",
                description: "The home screen gives you quick access to all features of the app. Tap any button to navigate to that section.",
                position: .center,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 2,
                title: "Names and Explanations",
                description: "Tap here to browse the complete list of Allah's 99 names with detailed explanations.",
                position: .center,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 3,
                title: "Flashcard Learning",
                description: "Use interactive flashcards to memorize the names and their meanings.",
                position: .center,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 4,
                title: "Duas with 99 Names",
                description: "Discover duas (supplications) associated with the 99 names of Allah.",
                position: .center,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 5,
                title: "Test Your Knowledge",
                description: "Challenge yourself with quizzes to reinforce your learning.",
                position: .center,
                buttonText: "Got it!"
            )
        ]
    }
}

// MARK: - CardView Tutorial Implementation
extension CardView {
    func tutorialSteps() -> [TutorialStep] {
        // Define your steps here
        return [
            TutorialStep(
                id: 0,
                title: "Welcome to Flashcards!",
                description: "Let's quickly go through the main features of this app.",
                position: .center,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 1,
                title: "Flip Cards",
                description: "Tap the 'Show meaning' button to see the meaning of each card.",
                position: .bottom,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 2,
                title: "Navigate Cards",
                description: "Use these arrows to move between cards in your deck.",
                position: .top,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 3,
                title: "Jump to Card",
                description: "Tap the card counter to jump directly to a specific card.",
                position: .top,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 4,
                title: "Zoom In",
                description: "In portrait mode, pinch to zoom in on card details.",
                position: .center,
                buttonText: "Got it!"
            )
        ]
    }
}

// MARK: - QuizView Tutorial Implementation
extension QuizView {
    func tutorialSteps() -> [TutorialStep] {
        return [
            TutorialStep(
                id: 0,
                title: "Quiz Mode",
                description: "Test your knowledge by answering questions about the cards.",
                position: .center,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 1,
                title: "Multiple Choice",
                description: "Select the correct answer from the options provided.",
                position: .center,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 2,
                title: "Results",
                description: "After completing the quiz, you'll see your score and can try again if needed.",
                position: .bottom,
                buttonText: "Got it!"
            )
        ]
    }
}

// MARK: - Scroll_Names Tutorial Implementation
extension Scroll_Names {
    func tutorialSteps() -> [TutorialStep] {
        return [
            TutorialStep(
                id: 0,
                title: "99 Names View",
                description: "This view allows you to explore all 99 Names of Allah.",
                position: .center,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 1,
                title: "Categories",
                description: "Filter names by categories using these color-coded circles.",
                position: .top,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 2,
                title: "Jump to Name",
                description: "Enter a number to scroll directly to a specific name.",
                position: .top,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 3,
                title: "Auto-Scrolling",
                description: "Press 'Start' to begin automatic scrolling with audio recitation.",
                position: .bottom,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 4,
                title: "Name Details",
                description: "Tap on any name to see detailed information about it.",
                position: .center,
                buttonText: "Got it!"
            )
        ]
    }
}

// MARK: - NameDetailView Tutorial Implementation
extension NameDetailView {
    func tutorialSteps() -> [TutorialStep] {
        return [
            TutorialStep(
                id: 0,
                title: "Name Details",
                description: "This view shows all information about a specific Name of Allah.",
                position: .top,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 1,
                title: "Arabic Text",
                description: "View the original Arabic text and its translation.",
                position: .center,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 2,
                title: "Meaning & Context",
                description: "Scroll down to see the meaning, description, and Quranic context.",
                position: .bottom,
                buttonText: "Got it!"
            )
        ]
    }
}

// MARK: - DuaSearchView Tutorial Implementation
extension DuaSearchView {
    func tutorialSteps() -> [TutorialStep] {
        return [
            TutorialStep(
                id: 0,
                title: "Dua Search",
                description: "Find duas related to specific qualities or names of Allah.",
                position: .top,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 1,
                title: "Filter by Quality",
                description: "Tap on a quality to see related duas, or collapse this section using the arrow button.",
                position: .top,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 2,
                title: "Search by Name",
                description: "Type in the search bar to find duas by name.",
                position: .top,
                buttonText: "Next"
            ),
            TutorialStep(
                id: 3,
                title: "Dua Details",
                description: "Tap the arrow on any dua to expand and see the full content and details.",
                position: .center,
                buttonText: "Got it!"
            )
        ]
    }
}


// MARK: - Manual Tutorial Button for Settings
struct SettingsView: View {
    @EnvironmentObject var tutorialManager: TutorialManager
    
    var body: some View {
        Form {
            Section(header: Text("Help")) {
                Button("Show Tutorial Again") {
                    tutorialManager.startTutorial()
                }
            }
            // Other settings...
        }
    }
}
