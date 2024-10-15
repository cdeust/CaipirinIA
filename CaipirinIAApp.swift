//
//  CaipirinIAApp.swift
//  CaipirinIA
//
//  Created by Clément Deust on 28/08/2024.
//

import SwiftUI

@main
struct CaipirinIAApp: App {
    @StateObject private var appState = DependencyContainer.shared.resolve(AppState.self)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

