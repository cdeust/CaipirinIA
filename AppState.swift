//
//  AppState.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var cocktailIngredients: [String] = []
    @Published var detectedItems: [DetectedItem] = []
    @Published var preparations: [Preparation] = []
    @Published var navigationStack: [String] = []

    private let preparationsKey = "preparationsKey"

    init() {
        loadPreparations()
    }

    func addPreparation(_ preparation: Preparation) {
        preparations.insert(preparation, at: 0) // Insert at the beginning
        savePreparations()
    }

    func clearPreparations() {
        preparations.removeAll()
        savePreparations()
    }

    private func savePreparations() {
        if let encoded = try? JSONEncoder().encode(preparations) {
            UserDefaults.standard.set(encoded, forKey: preparationsKey)
        }
    }

    private func loadPreparations() {
        if let savedData = UserDefaults.standard.data(forKey: preparationsKey),
           let decoded = try? JSONDecoder().decode([Preparation].self, from: savedData) {
            preparations = decoded
        }
    }

    func deletePreparation(_ preparation: Preparation) {
        if let index = preparations.firstIndex(where: { $0.id == preparation.id }) {
            preparations.remove(at: index)
            savePreparations()
        }
    }
        
    func push(_ view: String) {
        navigationStack.append(view)
    }
    
    func pop() {
        if !navigationStack.isEmpty {
            navigationStack.removeLast()
        }
    }
}
