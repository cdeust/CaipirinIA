//
//  Models.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import Foundation

struct CocktailResponse: Codable {
    let drinks: [Cocktail]?
}

struct Cocktail: Codable, Identifiable {
    let idDrink: String
    let strDrink: String
    let strDrinkThumb: String
    let strInstructions: String?
    
    // Properties to hold ingredients and their measurements
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?

    // Computed property to combine ingredients and measurements
    var ingredients: [String] {
        var result: [String] = []
        
        let ingredients = [
            strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
            strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
            strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        ]
        
        let measurements = [
            strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5,
            strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10,
            strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15
        ]
        
        for (index, ingredient) in ingredients.enumerated() {
            if let ingredient = ingredient, !ingredient.isEmpty {
                let measurement = measurements[index] ?? ""
                result.append("\(ingredient) - \(measurement)")
            }
        }
        
        return result
    }

    var id: String { idDrink }
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
