//
//  ContentView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct ContentView: View {
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    var body: some View {
        HomeView(container: container)
            .environmentObject(container.resolve(AppState.self))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let container = DependencyContainer()
        ContentView(container: container)
            .environmentObject(container.resolve(AppState.self))
    }
}
