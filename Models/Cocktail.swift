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
            if let ingredient = ingredient?.trimmingCharacters(in: .whitespacesAndNewlines), !ingredient.isEmpty {
                let measurement = measurements[index]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                let measurementDisplay = measurement.isEmpty ? "" : "\(measurement) of "
                let name = ingredient
                let type = determineIngredientType(for: name)
                result.append(Ingredient(name: name, type: type))
            }
        }
        
        return result
    }
    
    var id: String { idDrink }
    
    // Helper function to determine IngredientType based on ingredient name
    private func determineIngredientType(for ingredientName: String) -> IngredientType {
        let lowercasedName = ingredientName.lowercased()
        
        // Define keywords for each type
        let baseSpirits = ["tequila", "vodka", "rum", "gin", "whiskey", "brandy", "cognac", "scotch"]
        let modifiers = ["triple sec", "cointreau", "dry vermouth", "sweet vermouth", "amaretto", "orange liqueur"]
        let sweeteners = ["sugar", "simple syrup", "honey", "agave nectar"]
        let sours = ["lime juice", "lemon juice", "sour mix"]
        let bitters = ["angostura bitters", "orange bitters", "peach bitters"]
        let garnishes = ["salt", "sugar rim", "olive", "cherry", "lime wedge", "lemon twist", "mint sprig"]
        
        if baseSpirits.contains(where: { lowercasedName.contains($0) }) {
            return .baseSpirit
        } else if modifiers.contains(where: { lowercasedName.contains($0) }) {
            return .modifier
        } else if sweeteners.contains(where: { lowercasedName.contains($0) }) {
            return .sweetener
        } else if sours.contains(where: { lowercasedName.contains($0) }) {
            return .sour
        } else if bitters.contains(where: { lowercasedName.contains($0) }) {
            return .bitter
        } else if garnishes.contains(where: { lowercasedName.contains($0) }) {
            return .garnish
        } else {
            return .other
        }
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

enum IngredientType {
    case baseSpirit
    case modifier
    case sweetener
    case sour
    case bitter
    case garnish
    case other
}

extension IngredientType {
    init(ingredientName: String) {
        let lowercasedName = ingredientName.lowercased()
        switch lowercasedName {
        case "tequila", "vodka", "rum", "gin", "whiskey", "bourbon", "scotch":
            self = .baseSpirit
        case "triple sec", "vermouth", "schnapps", "amaretto":
            self = .modifier
        case "simple syrup", "honey", "agave nectar":
            self = .sweetener
        case "lime juice", "lemon juice", "orange juice":
            self = .sour
        case "angostura bitters", "pimento bitters":
            self = .bitter
        case "salt", "sugar", "olive", "cherry", "mint":
            self = .garnish
        default:
            self = .other
        }
    }
}

struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let type: IngredientType
}
