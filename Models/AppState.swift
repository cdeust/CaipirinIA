//
//  AppState.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var favoriteCocktails: [String] = []
    @Published var detectedItems: [DetectedItem] = []
}
