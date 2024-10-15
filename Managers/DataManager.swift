//
//  DataManager.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private let defaults = UserDefaults.standard

    private init() {}

    func saveCocktails(_ cocktails: [Cocktail]) {
        if let data = try? JSONEncoder().encode(cocktails) {
            defaults.set(data, forKey: "SavedCocktails")
        }
    }

    func loadCocktails() -> [Cocktail] {
        if let data = defaults.data(forKey: "SavedCocktails"),
           let cocktails = try? JSONDecoder().decode([Cocktail].self, from: data) {
            return cocktails
        }
        return []
    }
}
