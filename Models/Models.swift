//
//  Models.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import Foundation

struct Recipe: Identifiable, Decodable {
    var id: Int
    var title: String
    var imageType: String
    var usedIngredientCount: Int
    var missedIngredientCount: Int
    var extendedIngredients: [Ingredient]
    var analyzedInstructions: [Instruction]
}

struct Ingredient: Identifiable, Decodable {
    var id: Int
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
