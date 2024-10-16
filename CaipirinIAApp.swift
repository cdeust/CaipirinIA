//
//  CaipirinIAApp.swift
//  CaipirinIA
//
//  Created by Clément Deust on 28/08/2024.
//

import SwiftUI

@main
struct CaipirinIAApp: App {
    let container = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
        }
    }
}

