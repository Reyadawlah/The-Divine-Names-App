//
//  Scroll Names.swift
//  The Divine Names
//
//  Created by Reya Dawlah on 6/7/23.
//

import SwiftUI
import AVFoundation

let names : [String] = ["Ar Rahman", "Ar Raheem", "Al Malik", "Al Quddus", "As Salaam", "Al Mu'min", "Al Muhaymin", "Al Azeez", "Al Jabbar", "Al Mutakabbir", "Al Khaaliq", "Al Bari'", "Al Musawwir", "Al Ghaffar", "Al Qahhar", "Al Wahhab", "Ar Razzaaq", "Al Fattah", "Al Aleem", "Al Qaabid", "Al Baasit", "Al Khaafidh", "Ar Raafi'", "Al Mu'izz", "Al Mudhill", "As Samee'", "Al Baseer", "Al Hakam", "Al 'Adl", "Al Lateef", "Al Khabeer", "Al Haleem", "Al 'Azeem", "Al Ghafoor", "Ash Shakoor", "Al 'Aliyy", "Al Kabeer", "Al Hafeedh", "Al Muqeet", "Al Haseeb", "Al Jaleel", "Al Kareem", "Ar Raqeeb", "Al Mujeeb", "Al Waasi'", "Al Hakeem", "Al Wadood", "Al Majeed", "Al Ba'ith", "Ash Shaheed", "Al Haqq", "Al Wakeel", "Al Qawiyy", "Al Mateen", "Al Waliyy", "Al Hameed", "Al Muhsee", "Al Mubdi", "Al Mu'eed", "Al Muhyee", "Al Mumeet", "Al Hayy", "Al Qayyoom", "Al Waajid", "Al Maajid", "Al Waahid", "Al Ahad", "As Samad", "Al Qadir", "Al Muqtadiir", "Al Muqaddim", "Al Mu'akhkhir", "Al Awwal", "Al Aakhir", "Adh Dhaahir", "Al Baatin", "Al Wali", "Al Muta'ali", "Al Barr", "At Tawwaab", "Al Muntaqim", "Al 'Afuww", "Ar Ra'oof", "Maalik-ul-Mulk", "Dhul-Jalaali wal-Ikraam", "Al Muqsit", "Al Jaami'", "Al Ghaniyy", "Al Mughni", "Al Mani'", "Ad Dharr", "An Nafi'", "An Nur", "Al Haadi", "Al Badee'", "Al Baaqi", "Al Waarith", "Ar Rasheed", "As Saboor"]
var player:AVAudioPlayer!

struct Scroll_Names: View {
    //private var numImages = 50
    @State private var currentIndex = 0
    @State private var isScrolling = false
    @State var scrollNum = ""
    @State var scrollToIndex : Int = 0
    @State private var isTimerRunning = false
    @State private var timer: Timer?
    @State private var scrollViewProxy: ScrollViewProxy?
    
    @State private var showDetailView : Bool = false
    var num = 0
    
    var body: some View {
        NavigationStack {
            VStack{
                TextField("Enter a number to scroll: ", text: $scrollNum)
                    .frame(height: 55)
                    .border(Color.gray)
                    .padding(.horizontal)
                    .keyboardType(.numberPad)
                Button("Jump to Name"){
                    withAnimation(.spring()){
                        if let index = Int(scrollNum){
                            scrollToIndex = index
                        }
                    }
                }
                .font(.system(size: 20))
                .italic()
                
                ScrollView(){
                    ScrollViewReader { proxy in
                        ForEach(0..<(names.count)){ num in
                            NavigationLink(destination: DetailView(num: num)) {
                                Text("\(num+1). \(names[num])")
                                    .font(.custom("Avenir-Book", fixedSize: 25))
                                    .padding()
                                    .frame(maxWidth: 350, maxHeight: 300)
                                    .background(Color.teal)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(15)
                                    .id(num + 1)
                            }
                            /*Button(action: {
                                NavigationLink("See details", isActive: $showDetailView){
                                    Text("DetailView")
                                    Image("\(num)_back")
                                        .resizable()
                                        .scaledToFit()
                                        .tag(num)
                                        .padding()
                                }
                            }){
                                Text("\(num+1). \(names[num])")
                            }
                            .font(.custom("Avenir-Book", fixedSize: 25))
                            .padding()
                            .frame(maxWidth: 350, maxHeight: 300)
                            .background(Color.teal)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                            .id(num + 1)
                            .sheet(isPresented: $showDetailView){
                             DetailView(num: num)
                             }*/
                            
                            /*Button("\(num+1). \(names[num])")(action:{
                             DetailView(num: self.num)
                             })
                             .font(.custom("Avenir-Book", fixedSize: 25))
                             .padding()
                             .frame(maxWidth: 350, maxHeight: 300)
                             .background(Color.teal)
                             .foregroundColor(Color.white)
                             .cornerRadius(15)
                             .id(num + 1)*/
                            
                        }
                        .onChange(of: scrollToIndex, perform: { value in
                            proxy.scrollTo(value, anchor: .top)
                        })
                        .overlay(GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    scrollViewProxy = proxy // Assign proxy to scrollViewProxy
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
                        
                    }
                }
                HStack {
                    Button(action: {
                        isScrolling.toggle() // Toggle the scrolling state
                        playSound()
                    }) {
                        Text(isScrolling ? "Stop" : "Start")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        scrollToTop()
                    }) {
                        Text("Scroll to Top")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    func startScrolling() {
        guard timer == nil, let proxy = scrollViewProxy else {
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % names.count
                proxy.scrollTo(currentIndex, anchor: .top) // Use proxy here
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
            currentIndex = 0
            scrollViewProxy?.scrollTo(1, anchor: .top)
        }
    }
    func playSound(){
        guard let url = Bundle.main.url(forResource: "Allah's names recording 1-19", withExtension: "mp3") else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("\(error)")
        }
    }
    func stopSound() {
        player?.stop()
        player = nil
    }
}

struct Scroll_Names_Previews: PreviewProvider {
    static var previews: some View {
        Scroll_Names()
    }
}
