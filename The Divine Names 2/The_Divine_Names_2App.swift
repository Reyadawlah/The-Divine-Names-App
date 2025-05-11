//
//  The_Divine_Names_2App.swift
//  The Divine Names 2
//
//  Created by Reya Dawlah on 3/9/25.
//

import SwiftUI

@main
struct The_Divine_Names_2App: App {
    @StateObject private var viewModel = AppViewModel()
    @StateObject private var tutorialManager = TutorialManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(tutorialManager)
        }
    }
}
