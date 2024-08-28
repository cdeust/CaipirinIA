//
//  Models.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import Foundation

struct CocktailResponse: Decodable {
    let cocktails: [Cocktail]
}

struct Cocktail: Identifiable, Decodable {
    var id: Int
    var title: String
    var image: String
    var extendedIngredients: [Ingredient]
    var instructions: String
}

struct Ingredient: Identifiable, Decodable {
    var id: Int
    var name: String
    var amount: Double
    var original: String
}

struct Instruction: Decodable {
    var steps: [Step]
}

struct Step: Identifiable, Decodable {
    var number: Int
    var step: String
    
    var id: Int {
        return number
    }
}

struct DetectedItem: Identifiable {
    var id = UUID()
    var name: String
    var confidence: Float
    var boundingBox: CGRect
}
