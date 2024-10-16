//
//  ContentView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isCameraViewActive: Bool = false
    @Namespace private var animationNamespace
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HomeView()
            .environmentObject(appState)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}
