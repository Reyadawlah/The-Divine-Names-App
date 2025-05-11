//
//  ContentView.swift
//  The Divine Names 2
//
//  Created by Reya Dawlah on 3/9/25.
//

import SwiftUI
import AVFoundation

// MARK: - Button Styles
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

// MARK: - Dynamic Stack Component
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

// MARK: - Data Models
struct IslamicName: Identifiable, Hashable {
    let id = UUID()
    let number: Int
    let nameEnglish: String
    let meaning: String
    
    // Additional properties for enhanced detail view
    var nameArabic: String?
    var description: String?
    var quranReference: String?
    var occurrencesInQuran: Int?
    
    // Computed property for image name in assets
    var imageName: String {
        return "\(number)"
    }
    
    var imageBackName: String {
        return "\(number)_back"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: IslamicName, rhs: IslamicName) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Sample Data
class DataProvider {
    static let names: [String] = ["Ar Rahmaan", "Ar Raheem", "Al Malik", "Al Quddoos",
        "As Salaam", "Al Mu'min", "Al Muhaymin", "Al 'Azeez",
        "Al Jabbaar", "Al Mutakabbir", "Al Khaaliq", "Al Baari'",
        "Al Musawwir", "Al Ghaffaar", "Al Qahhaar", "Al Wahhaab",
        "Ar Razzaaq", "Al Fattaah", "Al 'Aleem", "Al Qaabid",
        "Al Baasit", "Al Khaafid", "Ar Raafi'", "Al Mu'izz",
        "Al Mudhill", "As Samee'", "Al Baseer", "Al Hakam",
        "Al 'Adl", "Al Lateef", "Al Khabeer", "Al Haleem",
        "Al 'Azeem", "Al Ghafoor", "Ash Shakoor", "Al 'Aliyy",
        "Al Kabeer", "Al Hafeez", "Al Muqeet", "Al Haseeb",
        "Al Jaleel", "Al Kareem", "Ar Raqeeb", "Al Mujeeb",
        "Al Waasi'", "Al Hakeem", "Al Wadood", "Al Majeed",
        "Al Baa'ith", "Ash Shaheed", "Al Haqq", "Al Wakeel",
        "Al Qawiyy", "Al Mateen", "Al Waliyy", "Al Hameed",
        "Al Muhsee", "Al Mubdee", "Al Mu'eed", "Al Muhyee",
        "Al Mumeet", "Al Hayy", "Al Qayyoom", "Al Waajid",
        "Al Maajid", "Al Waahid", "Al Ahad", "As Samad",
        "Al Qaadir", "Al Muqtadir", "Al Muqaddim", "Al Muakhkhir",
        "Al Awwal", "Al Aakhir", "Adh Dhaahir", "Al Baatin",
        "Al Waali", "Al Muta'aali", "Al Barr", "At Tawwaab",
        "Al Muntaqim", "Al 'Afuww", "Ar Raoof", "Maalik-ul-Mulk",
        "Dhul-Jalaali wal-Ikraam", "Al Muqsit", "Al Jaami'",
        "Al Ghaniyy", "Al Mughniyy", "Al Maani'", "Ad Dhaar",
        "An Naafi'", "An Noor", "Al Haadi", "Al Badee'",
        "Al Baaqi", "Al Waarith", "Ar Rasheed", "As Saboor"]
    
    // Mapping of English name to meanings
    static let meanings: [String: String] = [
        "Ar Rahman": "The Most Compassionate",
        "Ar Raheem": "The Most Merciful",
        "Al Malik": "The King, The Sovereign",
        "Al Quddoos": "The Most Holy",
        "As Salaam": "The Source of Peace",
        "Al Mu'min": "The Guardian of Faith",
        "Al Muhaymin": "The Protector",
        "Al Azeez": "The Mighty",
        "Al Jabbaar": "The Compeller",
        "Al Mutakabbir": "The Greatest",
        "Al Khaaliq": "The Creator",
        "Al Baari'": "The Maker",
        "Al Musawwir": "The Fashioner",
        "Al Ghaffaar": "The Ever-Forgiving",
        "Al Qahhaar": "The All-Prevailing",
        "Al Wahhaab": "The Supreme Bestower",
        "Ar Razzaaq": "The Provider",
        "Al Fattaah": "The Opener",
        "Al 'Aleem": "The All-Knowing",
        "Al Qaabid": "The Withholder",
        "Al Baasit": "The Amplifier",
        "Al Khaafid": "The Reducer",
        "Ar Raafi'": "The Elevator",
        "Al Mu'izz": "The Honorer",
        "Al Mudhill": "The Humiliator",
        "As Samee'": "The All-Hearing",
        "Al Baseer": "The All-Seeing",
        "Al Hakam": "The Impartial Judge",
        "Al 'Adl": "The Utterly Just",
        "Al Lateef": "The Subtle One",
        "Al Khabeer": "The All-Acquainted",
        "Al Haleem": "The Most Forbearing",
        "Al 'Azeem'": "The Magnificent One",
        "Al Ghafoor": "The Most Forgiving",
        "Ash Shakoor": "The Most Appreciative",
        "Al 'Aliyy": "The Most High",
        "Al Kabeer": "The Most Great",
        "Al Hafeez": "The Preserver",
        "Al Muqeet": "The Nourisher",
        "Al Haseeb": "The Reckoner",
        "Al Jaleel": "The Majestic",
        "Al Kareem": "The Most Generous",
        "Ar Raqeeb": "The Observer",
        "Al Mujeeb": "The Responsive",
        "Al Waasi'": "The Boundless",
        "Al Hakeem": "The All Wise",
        "Al Wadood": "The Most Loving",
        "Al Majeed": "The Glorious",
        "Al Baa'ith": "The Resurrector",
        "Ash Shaheed": "The Witness",
        "Al Haqq": "The Absolute Truth",
        "Al Wakeel": "The Trustee",
        "Al Qawiyy": "The Most Strong",
        "Al Mateen": "The Steadfast",
        "Al Waliyy": "The Protecting Associate",
        "Al Hameed": "The Praiseworthy",
        "Al Muhsee": "The Counter",
        "Al Mubdee": "The Originator",
        "Al Mu'eed": "The Restorer",
        "Al Muhyee": "The Giver of Life",
        "Al Mumeet": "The Bringer of Death",
        "Al Hayy": "The Ever-Living",
        "Al Qayyoom": "The Self-Subsisting",
        "Al Waajid": "The Perceiver",
        "Al Maajid": "The Illustrious",
        "Al Waahid": "The One",
        "Al Ahad": "The Unique",
        "As Samad": "The Eternal",
        "Al Qaadir": "The Capable",
        "Al Muqtadir": "The Omnipotent",
        "Al Muqaddim": "The Expediter",
        "Al Muakhkhir": "The Delayer",
        "Al Awwal": "The First",
        "Al Aakhir": "The Last",
        "Adh Dhaahir": "The Manifest",
        "Al Baatin": "The Hidden One",
        "Al Waali": "The Patron",
        "Al Muta'aali": "The Supremely Exalted",
        "Al Barr": "The Source of Goodness",
        "At Tawwab": "The Ever-Pardoning",
        "Al Muntaqim": "The Avenger",
        "Al 'Afuww": "The Pardoner",
        "Ar Raoof": "The Most Kind",
        "Maalik-ul-Mulk": "The Owner of the Dominion",
        "Dhul-Jalaali wal-Ikraam": "Possessor of Glory and Honor",
        "Al Muqsit": "The Requiter",
        "Al Jaami'": "The Gatherer",
        "Al Ghaniyy": "The Rich",
        "Al Mughniyy": "The Enricher",
        "Al Maani'": "The Preventer",
        "Ad Dhaar": "The Distresser",
        "Ad Naafi'": "The Benefactor",
        "An Noor": "The Light",
        "Al Haadi": "The Guide",
        "Al Badee'": "The Incomparable Originator",
        "Al Baaqi": "The Everlasting",
        "Al Waarith": "The Inheritor",
        "Ar Rasheed": "The Infallible Teacher",
        "As Saboor": "The Patient"
    ]
    
    static let duaQualities = [
        "Forgiveness",
        "Guidance",
        "Patience",
        "Protection",
        "Rizq",
        "Praise",
        "Remembrance",
        "Mercy"
    ]
    
    // Generate QuizQuestion objects
    static func generateRandomQuizQuestions(count: Int = 10) -> [QuizQuestion] {
        var questions: [QuizQuestion] = []
        
        // Names and meanings to work with
        let namesAndMeanings = zip(names, names.map { getMeaning(for: $0) }).map { ($0, $1) }
        
        // 1. Meaning questions - "What is the meaning of [name]?"
        for _ in 0..<(count/3) {
            if let (name, correctMeaning) = namesAndMeanings.randomElement() {
                // Get 3 wrong meanings that are different from the correct one
                var wrongOptions = meanings.values.filter { $0 != correctMeaning }.shuffled().prefix(3)
                
                // All options including the correct one
                var options = Array(wrongOptions)
                options.append(correctMeaning)
                
                // Shuffle options and track the correct index
                options.shuffle()
                let correctIndex = options.firstIndex(of: correctMeaning) ?? 0
                
                questions.append(QuizQuestion(
                    question: "What is the meaning of \(name)?",
                    options: options,
                    correctAnswerIndex: correctIndex
                ))
            }
        }
        
        // 2. Matching questions - "Which name means [meaning]?"
        for _ in 0..<(count/3) {
            if let (correctName, meaning) = namesAndMeanings.randomElement() {
                // Get 3 wrong names
                var wrongOptions = names.filter { $0 != correctName }.shuffled().prefix(3)
                
                // All options including the correct one
                var options = Array(wrongOptions)
                options.append(correctName)
                
                // Shuffle options and track the correct index
                options.shuffle()
                let correctIndex = options.firstIndex(of: correctName) ?? 0
                
                questions.append(QuizQuestion(
                    question: "Which name means '\(meaning)'?",
                    options: options,
                    correctAnswerIndex: correctIndex
                ))
            }
        }
        
        // 3. Match name to meaning questions
        for _ in 0..<(count - questions.count) {
            if let (correctName, correctMeaning) = namesAndMeanings.randomElement() {
                // Create one correct pairing
                let correctOption = "\(correctName) - \(correctMeaning)"
                
                // Create 3 incorrect pairings
                var wrongOptions: [String] = []
                for _ in 0..<3 {
                    if let wrongName = names.filter({ $0 != correctName }).randomElement(),
                       let wrongMeaning = meanings.values.filter({ $0 != correctMeaning }).randomElement() {
                        wrongOptions.append("\(wrongName) - \(wrongMeaning)")
                    }
                }
                
                // Fill up to 3 if we don't have enough
                while wrongOptions.count < 3 {
                    if let (name, meaning) = namesAndMeanings.randomElement() {
                        let option = "\(name) - \(meaning)"
                        if option != correctOption && !wrongOptions.contains(option) {
                            wrongOptions.append(option)
                        }
                    }
                }
                
                // Combine all options
                var options = wrongOptions
                options.append(correctOption)
                
                // Shuffle and track correct index
                options.shuffle()
                let correctIndex = options.firstIndex(of: correctOption) ?? 0
                
                questions.append(QuizQuestion(
                    question: "Which of these pairings is correct?",
                    options: options,
                    correctAnswerIndex: correctIndex
                ))
            }
        }
        // True/False questions
        for _ in 0..<(count/5) {
            let isCorrect = Bool.random()
            if let (name, correctMeaning) = namesAndMeanings.randomElement(),
               let wrongMeaning = meanings.values.filter({ $0 != correctMeaning }).randomElement() {
                
                let displayedMeaning = isCorrect ? correctMeaning : wrongMeaning
                
                questions.append(QuizQuestion(
                    question: "True or False: '\(name)' means '\(displayedMeaning)'",
                    options: ["True", "False"],
                    correctAnswerIndex: isCorrect ? 0 : 1
                ))
            }
        }
        
        // Shuffle questions and return requested count
        return questions.shuffled().prefix(count).map { $0 }
    }
    static func getMeaning(for name: String) -> String {
        return meanings[name] ?? "Divine Name"
    }
    
}

// MARK: - Quiz Model
struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    var selectedAnswerIndex: Int? = nil
}

// MARK: - View Model (Shared State)
class AppViewModel: ObservableObject {
    @Published var quizQuestions: [QuizQuestion] = []
    @Published var selectedTab: Int = 0
    @Published var names: [String] = DataProvider.names
    @Published var searchText = ""
    @Published var scrollToIndex: Int? = nil
//    @Published var quizQuestions: [QuizQuestion] = DataProvider.generateQuizQuestions()
    @Published var showingDetailView = false
    @Published var selectedName: String = ""
    @Published var selectedNameIndex: Int = 0
    @Published var currentView: AppView = .cards
    @Published var selectedDua = ""
    
    enum AppView: Int {
        case home = 0
        case cards = 1
        case list = 2
        case quiz = 3
        case search = 4
    }
    func refreshQuizQuestions(count: Int = 10) {
        quizQuestions = DataProvider.generateRandomQuizQuestions(count: count)
    }
    // Call this in init or when starting a new quiz
    init() {
        refreshQuizQuestions()
    }
    func getNameMeaning(_ name: String) -> String {
        return DataProvider.meanings[name] ?? "The Divine Name"
    }
    
    func getNamesForQuality(_ quality: String) -> [String] {
        switch quality.lowercased() {
        case "forgiveness":
            return names.filter { $0.contains("Ghafoor") || $0.contains("'Afuww") || $0.contains("Tawwaab") }
        case "mercy":
            return names.filter { $0.contains("Rahman") || $0.contains("Raheem") || $0.contains("Ra'oof") }
        case "protection":
            return names.filter { $0.contains("Hafeedh") || $0.contains("Waali") || $0.contains("Muhaymin") }
        default:
            return []
        }
    }
}

// MARK: - Cards View (Improved Version)
struct CardView: View {
    @EnvironmentObject var viewModel: AppViewModel
    private var numImages = 99

    @State private var flip: Bool = false
    @State private var flipDegrees: Double = 0.0
    @State private var flipText: String = "Show meaning"
    @State private var scale: CGFloat = 1.0
    @State private var currentIndex: Int = 1
    @State private var jumpToText: String = ""
    @State private var showJumpToAlert: Bool = false
    @State private var showJumpSheet: Bool = false
    @State private var orientation = UIDevice.current.orientation

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height

            NavigationView {
                VStack {
                    if isLandscape {
                        // LANDSCAPE MODE
                        VStack {
                            // Card Counter
                            Button(action: {
                                showJumpSheet = true
                            }) {
                                Text("\(currentIndex)/\(numImages)")
                                    .font(.headline)
                                    .padding(8)
                                    .frame(width: 80)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.teal, lineWidth: 2))
                                    .foregroundColor(.teal)
                            }
                            .padding(.bottom, 10)

                            // Arrows and Card
                            HStack(alignment: .center) {
                                Button(action: {
                                    if currentIndex > 1 {
                                        withAnimation {
                                            currentIndex -= 1
                                            resetCardFlip()
                                        }
                                    }
                                }) {
                                    Image(systemName: "chevron.left.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(currentIndex > 1 ? .teal : .gray)
                                }
                                .disabled(currentIndex <= 1)

                                cardContent(for: currentIndex, isLandscape: true)
                                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.6)

                                Button(action: {
                                    if currentIndex < numImages {
                                        withAnimation {
                                            currentIndex += 1
                                            resetCardFlip()
                                        }
                                    }
                                }) {
                                    Image(systemName: "chevron.right.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(currentIndex < numImages ? .teal : .gray)
                                }
                                .disabled(currentIndex >= numImages)
                            }

                            // Show Meaning Button
                            Button(flipText) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    flipDegrees += 180
                                    flip.toggle()
                                    flipText = flip ? "Hide" : "Show meaning"
                                }
                            }
                            .buttonStyle(GrowingButton())
                            .padding(.top)
                        }
                        .padding()
                    } else {
                        // PORTRAIT MODE
                        VStack(spacing: 15) {
                            // Arrows + Card Counter (Above the card)
                            HStack(spacing: 40) {
                                Button(action: {
                                    if currentIndex > 1 {
                                        withAnimation {
                                            currentIndex -= 1
                                            resetCardFlip()
                                        }
                                    }
                                }) {
                                    Image(systemName: "arrow.left.circle.fill")
                                        .font(.system(size: 36))
                                        .foregroundColor(currentIndex > 1 ? .teal : .gray)
                                }
                                .disabled(currentIndex <= 1)

                                Button(action: {
                                    showJumpSheet = true
                                }) {
                                    Text("\(currentIndex)/\(numImages)")
                                        .font(.subheadline)
                                        .padding(8)
                                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.teal, lineWidth: 2))
                                }

                                Button(action: {
                                    if currentIndex < numImages {
                                        withAnimation {
                                            currentIndex += 1
                                            resetCardFlip()
                                        }
                                    }
                                }) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 36))
                                        .foregroundColor(currentIndex < numImages ? .teal : .gray)
                                }
                                .disabled(currentIndex >= numImages)
                            }

                            // Card and Button Container - wrapped in a VStack
                            VStack(spacing: 10) {
                                // Flashcard
                                ZStack {
                                    ForEach(1..<numImages+1, id: \.self) { num in
                                        if num == currentIndex {
                                            cardContent(for: num, isLandscape: false)
                                                .transition(.opacity)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                // Reduce the frame height to make room for the button closer to the card
                                .frame(height: geometry.size.height * 0.65)
                                
                                // Show Meaning Button - moved up closer to the card
                                Button(flipText) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        flipDegrees += 180
                                        flip.toggle()
                                        flipText = flip ? "Hide meaning" : "Show meaning"
                                    }
                                }
                                .buttonStyle(GrowingButton())
                                .padding(.top, 5) // Reduced top padding to bring it closer to the card
                            }
                            
                            // Adding a Spacer to push content up
                            Spacer()
                        }
                        .padding(.top)
                    }
                }
                .sheet(isPresented: $showJumpSheet) {
                    VStack(spacing: 20) {
                        Text("Jump to card #")
                            .font(.headline)
                        
                        TextField("1-\(numImages)", text: $jumpToText)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .frame(width: 150)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
                                }
                            }

                        Button("Go") {
                            jumpToCard()
                            showJumpSheet = false
                        }
                        .buttonStyle(GrowingButton())

                        Button("Cancel") {
                            showJumpSheet = false
                        }
                        .foregroundColor(.red)
                        .padding(.top, 5)
                    }
                    .padding()
                }
                .alert(isPresented: $showJumpToAlert) {
                    Alert(
                        title: Text("Invalid Card Number"),
                        message: Text("Please enter a number between 1 and \(numImages)."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .navigationViewStyle(.stack)
        }
    }



    // MARK: - Card Content
    @ViewBuilder
    private func cardContent(for num: Int, isLandscape: Bool) -> some View {
        ZStack {
            Image("\(num)")
                .resizable()
                .scaledToFit()
                .padding()
                .opacity(flip ? 0 : 1)
                .rotation3DEffect(.degrees(flipDegrees), axis: (x: 0.0, y: 1.0, z: 0.0))

            Image("back\(num)")
                .resizable()
                .scaledToFit()
                .padding()
                .opacity(flip ? 1 : 0)
                .rotation3DEffect(.degrees(flipDegrees - 180), axis: (x: 0.0, y: 1.0, z: 0.0))
        }
        .scaleEffect(isLandscape ? 1.4 : scale)
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    if !isLandscape {
                        self.scale = min(max(value, 0.5), 4.0)
                    }
                }
                .onEnded { _ in
                    if !isLandscape {
                        withAnimation {
                            self.scale = 1.0
                        }
                    }
                }
        )
    }

    // MARK: - Helpers
    private func jumpToCard() {
        if let cardNumber = Int(jumpToText), cardNumber >= 1 && cardNumber <= numImages {
            withAnimation {
                currentIndex = cardNumber
                resetCardFlip()
                jumpToText = ""
            }
        } else {
            showJumpToAlert = true
            jumpToText = ""
        }
    }

    private func resetCardFlip() {
        withAnimation(.easeInOut(duration: 0.3)) {
            flip = false
            flipDegrees = 0
            flipText = "Show meaning"
            scale = 1.0
        }
    }
}


// MARK: - Detail View
struct DetailView: View {
    let num: Int
    @State private var returnView = false

    var body: some View {
        VStack {
            if let uiImage = UIImage(named: "back\(num+1)") {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .tag(num)
                    .padding()
            } else {
                Text("Image \(num+1)_back not found")
                    .foregroundColor(.red)
                    .font(.title)
                    .padding()
            }
        }
        .navigationBarTitle("Detail")
    }
}

// MARK: - Quiz View (Updated with Scrolling)
struct QuizView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var currentQuizIndex = 0
    @State private var showResults = false
    @State private var quizScore = 0
    
    var body: some View {
        ScrollView {
            VStack {
                if showResults {
                    // Quiz results view
                    VStack(spacing: 20) {
                        Text("Quiz Results")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        Text("You scored")
                            .font(.title)
                        
                        Text("\(quizScore) / \(viewModel.quizQuestions.count)")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                            .foregroundColor(quizScore > viewModel.quizQuestions.count / 2 ? .green : .red)
                        
                        Text("\(Int((Double(quizScore) / Double(viewModel.quizQuestions.count)) * 100))%")
                            .font(.title)
                            .padding(.bottom, 20)
                        
                        Button(action: {
                            // Reset quiz with fresh random questions
                            viewModel.refreshQuizQuestions()
                            currentQuizIndex = 0
                            showResults = false
                            quizScore = 0
                        }) {
                            Text("Try Again")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            withAnimation {
                                viewModel.selectedTab = 0
                            }
                        }) {
                            Text("Return to Cards")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.secondary)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .padding()
                    .frame(minHeight: UIScreen.main.bounds.height - 150)
                } else {
                    // Quiz questions
                    if currentQuizIndex < viewModel.quizQuestions.count {
                        QuizQuestionView(
                            question: $viewModel.quizQuestions[currentQuizIndex],
                            questionNumber: currentQuizIndex + 1,
                            totalQuestions: viewModel.quizQuestions.count,
                            nextQuestion: {
                                if viewModel.quizQuestions[currentQuizIndex].selectedAnswerIndex == viewModel.quizQuestions[currentQuizIndex].correctAnswerIndex {
                                    quizScore += 1
                                }
                                
                                if currentQuizIndex < viewModel.quizQuestions.count - 1 {
                                    currentQuizIndex += 1
                                } else {
                                    showResults = true
                                }
                            }
                        )
                    }
                }
            }
            .padding(.bottom, 30) // Add padding at the bottom for better scrolling
        }
        .navigationTitle("Test Your Knowledge")
    }
}

struct QuizQuestionView: View {
    @Binding var question: QuizQuestion
    let questionNumber: Int
    let totalQuestions: Int
    let nextQuestion: () -> Void
    @State private var showAnswer = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Progress info
            HStack {
                Text("Question \(questionNumber) of \(totalQuestions)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Question
            Text(question.question)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            // Answer options - removed Spacer() that was above this
            VStack(spacing: 15) {
                ForEach(0..<question.options.count, id: \.self) { index in
                    Button(action: {
                        question.selectedAnswerIndex = index
                        showAnswer = true
                    }) {
                        HStack {
                            Text("\(["A", "B", "C", "D"][index]). ")
                                .fontWeight(.bold)
                            
                            Text(question.options[index])
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            if showAnswer {
                                if question.selectedAnswerIndex == index {
                                    // Show checkmark or X based on selection
                                    Image(systemName: index == question.correctAnswerIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(index == question.correctAnswerIndex ? .green : .red)
                                } else if index == question.correctAnswerIndex && question.selectedAnswerIndex != question.correctAnswerIndex {
                                    // Show the correct answer when user selected wrong
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    // Highlight both the selected answer and correct answer
                                    showAnswer && index == question.correctAnswerIndex
                                    ? Color.green.opacity(0.2)
                                    : question.selectedAnswerIndex == index
                                      ? (showAnswer && index != question.correctAnswerIndex
                                         ? Color.red.opacity(0.2)
                                         : Color.blue.opacity(0.2))
                                      : Color.secondary.opacity(0.1)
                                )
                        )
                        .foregroundColor(.primary)
                    }
                    .disabled(showAnswer)
                    .padding(.horizontal)
                }
            }
            
            // Result message
            if showAnswer {
                HStack {
                    if question.selectedAnswerIndex == question.correctAnswerIndex {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Correct! Well done.")
                            .foregroundColor(.green)
                            .fontWeight(.bold)
                    } else {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.orange)
                        Text("The correct answer is: \(question.options[question.correctAnswerIndex])")
                            .foregroundColor(.primary)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(question.selectedAnswerIndex == question.correctAnswerIndex ? .green : .orange).opacity(0.1))
                )
                .padding(.horizontal)
            }
            
            // Next button
            if showAnswer {
                Button(action: {
                    showAnswer = false
                    nextQuestion()
                }) {
                    Text(questionNumber == totalQuestions ? "Finish Quiz" : "Next Question")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .frame(minHeight: UIScreen.main.bounds.height - 150) // Ensure minimum height for landscape mode
    }
}



// MARK: - Content View (Main App Structure)
struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()
    @StateObject private var tutorialManager = TutorialManager()
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            HomeView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            CardView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Cards", systemImage: "menucard.fill")
                }
                .tag(1)
            
            Scroll_Names()
                .environmentObject(viewModel)
                .tabItem {
                    Label("List", systemImage: "list.triangle")
                }
                .tag(2)
            
            QuizView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Quiz", systemImage: "questionmark.circle")
                }
                .tag(3)
            
            DuaSearchView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Dua", systemImage: "text.book.closed")
                }
                .tag(4)
        }
        .environmentObject(tutorialManager)
        .onChange(of: viewModel.selectedTab) { newTab in
            // When changing tabs, check if we need to show a tutorial for this tab
            if tutorialManager.hasSeenTutorial {
                tutorialManager.checkAndShowTutorialForTab(newTab)
            }
        }
        .overlay(
            Group {
                if tutorialManager.showingTutorial {
                    // Show the appropriate tutorial based on the current view for tutorial
                    if tutorialManager.currentViewForTutorial == 0 {
                        EnhancedTutorialOverlayView(steps: HomeView().tutorialSteps())
                    } else if tutorialManager.currentViewForTutorial == 1 {
                        EnhancedTutorialOverlayView(steps: CardView().tutorialSteps())
                    } else if tutorialManager.currentViewForTutorial == 2 {
                        EnhancedTutorialOverlayView(steps: Scroll_Names().tutorialSteps())
                    } else if tutorialManager.currentViewForTutorial == 3 {
                        EnhancedTutorialOverlayView(steps: QuizView().tutorialSteps())
                    } else if tutorialManager.currentViewForTutorial == 4 {
                        EnhancedTutorialOverlayView(steps: DuaSearchView().tutorialSteps())
                    }
                }
            }
        )
        .onAppear {
            // On first launch, start with the Home tutorial
            // and mark the app as having seen the main tutorial
            if !tutorialManager.hasSeenTutorial {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    tutorialManager.currentViewForTutorial = 0
                    tutorialManager.startTutorial()
                }
            }
        }
    }
}

//// MARK: - Preview
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

//#Preview {
//    ContentView()
//}

// MARK: - ContentView Preview with Tutorial
struct ContentView_WithTutorial_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AppViewModel()
        let tutorialManager = TutorialManager()
        
        // Set up to show the tutorial
        tutorialManager.showingTutorial = true
        tutorialManager.currentViewForTutorial = 0 // Show home tutorial
        
        return ContentView()
            .environmentObject(viewModel)
            .environmentObject(tutorialManager)
    }
}
