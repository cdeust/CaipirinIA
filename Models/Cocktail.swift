//
//  Cocktail.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import Foundation

struct CocktailResponse: Codable {
    let drinks: [Cocktail]?
}

struct Cocktail: Codable, Identifiable {
    let idDrink: String
    let strDrink: String
    let strDrinkAlternate: String?
    let strTags: String?
    let strVideo: String?
    let strCategory: String?
    let strIBA: String?
    let strAlcoholic: String?
    let strGlass: String?
    let strInstructions: String?
    let strInstructionsES: String?
    let strInstructionsDE: String?
    let strInstructionsFR: String?
    let strInstructionsIT: String?
    let strInstructionsZH_HANS: String?
    let strInstructionsZH_HANT: String?
    let strDrinkThumb: String?
    
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
    
    let strImageSource: String?
    let strImageAttribution: String?
    let strCreativeCommonsConfirmed: String?
    let dateModified: String?
    
    // Computed property to combine ingredients and measurements
    var ingredients: [Ingredient] {
        var result: [Ingredient] = []
        
        let ingredientsList = [
            strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
            strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
            strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        ]
        
        let measurements = [
            strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5,
            strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10,
            strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15
        ]
        
        for (index, ingredient) in ingredientsList.enumerated() {
            if let ingredient = ingredient?.trimmingCharacters(in: .whitespacesAndNewlines), !ingredient.isEmpty {
                let mappedIngredient = IngredientMapper.map(ingredient)
                let measurement = measurements[index]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                let measurementDisplay = measurement.isEmpty ? "" : "\(measurement) of "
                
                if let ingredientType = determineIngredientType(for: mappedIngredient) {
                    result.append(Ingredient(name: mappedIngredient, type: ingredientType))
                } else {
                    // Handle ingredients that may not match the predefined catalog
                    result.append(Ingredient(name: mappedIngredient, type: .other))
                }
            }
        }
        
        return result
    }
    
    var id: String { idDrink }
    
    // Helper function to determine IngredientType based on ingredient name
    private func determineIngredientType(for ingredientName: String) -> IngredientType? {
        // Use the ingredient catalog from IngredientMapper
        if let catalogItem = IngredientMapper.ingredientsCatalog.first(where: { $0.name.caseInsensitiveCompare(ingredientName) == .orderedSame }) {
            return catalogItem.type
        }
        
        // If the ingredient is not found in the catalog, return nil or .other
        return nil
    }
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

enum IngredientType: String, Codable {
    case baseSpirit
    case bitter
    case dairy
    case fruit
    case garnish
    case miscellaneous
    case mixer
    case modifier
    case sour
    case sweetener
    case other
}

struct Ingredient: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: IngredientType
}
