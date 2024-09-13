//
//  CocktailGenerator.swift
//  CaipirinIA
//
//  Created by Clément Deust on 31/08/2024.
//

import Foundation

class CocktailGenerator {
    func generateCocktails(fromDetected detectedIngredients: [String]) -> [Cocktail] {
        var generatedCocktails: [Cocktail] = []
        
        // Generate multiple unique cocktails
        for _ in 0..<3 {
            if let cocktail = generateCocktail(fromDetected: detectedIngredients) {
                generatedCocktails.append(cocktail)
            }
        }
        
        return generatedCocktails
    }

    func generateCocktail(fromDetected detectedIngredients: [String]) -> Cocktail? {
        guard let baseSpirit = selectBaseSpirit(from: detectedIngredients) else {
            return nil // A cocktail needs a base spirit
        }

        let modifiers = selectModifiers(from: detectedIngredients)
        let sweeteners = selectSweeteners(from: detectedIngredients)
        let sours = selectSours(from: detectedIngredients)
        let bitters = selectBitters(from: detectedIngredients)
        let garnishes = selectGarnishes(from: detectedIngredients)

        // Mixology logic for balancing the cocktail
        let balancedIngredients = balanceIngredients(baseSpirit: baseSpirit, modifiers: modifiers, sweeteners: sweeteners, sours: sours, bitters: bitters)
        let name = constructCocktailName(baseSpirit: baseSpirit, modifiers: modifiers, sours: sours)

        // Construct instructions, including the garnish if available
        let instructions = constructInstructions(ingredients: balancedIngredients, garnish: garnishes.first?.name)

        // Create a placeholder Cocktail object
        return Cocktail(
            idDrink: UUID().uuidString,
            strDrink: name,
            strDrinkAlternate: nil,
            strTags: "Generated",
            strVideo: nil,
            strCategory: "Generated",
            strIBA: nil,
            strAlcoholic: "Alcoholic",
            strGlass: "Cocktail glass",
            strInstructions: instructions,
            strInstructionsES: nil,
            strInstructionsDE: nil,
            strInstructionsFR: nil,
            strInstructionsIT: nil,
            strInstructionsZH_HANS: nil,
            strInstructionsZH_HANT: nil,
            strDrinkThumb: nil, // No image for generated cocktails
            strIngredient1: balancedIngredients.count > 0 ? balancedIngredients[0].0 : nil,
            strIngredient2: balancedIngredients.count > 1 ? balancedIngredients[1].0 : nil,
            strIngredient3: balancedIngredients.count > 2 ? balancedIngredients[2].0 : nil,
            strIngredient4: balancedIngredients.count > 3 ? balancedIngredients[3].0 : nil,
            strIngredient5: balancedIngredients.count > 4 ? balancedIngredients[4].0 : nil,
            strIngredient6: balancedIngredients.count > 5 ? balancedIngredients[5].0 : nil,
            strIngredient7: balancedIngredients.count > 6 ? balancedIngredients[6].0 : nil,
            strIngredient8: balancedIngredients.count > 7 ? balancedIngredients[7].0 : nil,
            strIngredient9: balancedIngredients.count > 8 ? balancedIngredients[8].0 : nil,
            strIngredient10: balancedIngredients.count > 9 ? balancedIngredients[9].0 : nil,
            strIngredient11: balancedIngredients.count > 10 ? balancedIngredients[10].0 : nil,
            strIngredient12: balancedIngredients.count > 11 ? balancedIngredients[11].0 : nil,
            strIngredient13: balancedIngredients.count > 12 ? balancedIngredients[12].0 : nil,
            strIngredient14: balancedIngredients.count > 13 ? balancedIngredients[13].0 : nil,
            strIngredient15: balancedIngredients.count > 14 ? balancedIngredients[14].0 : nil,
            strMeasure1: balancedIngredients.count > 0 ? balancedIngredients[0].1 : nil,
            strMeasure2: balancedIngredients.count > 1 ? balancedIngredients[1].1 : nil,
            strMeasure3: balancedIngredients.count > 2 ? balancedIngredients[2].1 : nil,
            strMeasure4: balancedIngredients.count > 3 ? balancedIngredients[3].1 : nil,
            strMeasure5: balancedIngredients.count > 4 ? balancedIngredients[4].1 : nil,
            strMeasure6: balancedIngredients.count > 5 ? balancedIngredients[5].1 : nil,
            strMeasure7: balancedIngredients.count > 6 ? balancedIngredients[6].1 : nil,
            strMeasure8: balancedIngredients.count > 7 ? balancedIngredients[7].1 : nil,
            strMeasure9: balancedIngredients.count > 8 ? balancedIngredients[8].1 : nil,
            strMeasure10: balancedIngredients.count > 9 ? balancedIngredients[9].1 : nil,
            strMeasure11: balancedIngredients.count > 10 ? balancedIngredients[10].1 : nil,
            strMeasure12: balancedIngredients.count > 11 ? balancedIngredients[11].1 : nil,
            strMeasure13: balancedIngredients.count > 12 ? balancedIngredients[12].1 : nil,
            strMeasure14: balancedIngredients.count > 13 ? balancedIngredients[13].1 : nil,
            strMeasure15: balancedIngredients.count > 14 ? balancedIngredients[14].1 : nil,
            strImageSource: nil,
            strImageAttribution: nil,
            strCreativeCommonsConfirmed: nil,
            dateModified: nil
        )
    }

    private func selectBaseSpirit(from detectedIngredients: [String]) -> String? {
        let baseSpirits = IngredientMapper.ingredientsCatalog.filter { $0.type == .baseSpirit }
        return baseSpirits.first { detectedIngredients.contains($0.name) }?.name
    }

    private func selectModifiers(from detectedIngredients: [String]) -> [String] {
        let modifiers = IngredientMapper.ingredientsCatalog.filter { $0.type == .modifier }
        return modifiers.filter { detectedIngredients.contains($0.name) }.map { $0.name }
    }

    private func selectSweeteners(from detectedIngredients: [String]) -> [String] {
        let sweeteners = IngredientMapper.ingredientsCatalog.filter { $0.type == .sweetener }
        return sweeteners.filter { detectedIngredients.contains($0.name) }.map { $0.name }
    }

    private func selectSours(from detectedIngredients: [String]) -> [String] {
        let sours = IngredientMapper.ingredientsCatalog.filter { $0.type == .sour }
        return sours.filter { detectedIngredients.contains($0.name) }.map { $0.name }
    }

    private func selectBitters(from detectedIngredients: [String]) -> [String] {
        let bitters = IngredientMapper.ingredientsCatalog.filter { $0.type == .bitter }
        return bitters.filter { detectedIngredients.contains($0.name) }.map { $0.name }
    }

    private func selectGarnishes(from detectedIngredients: [String]) -> [Ingredient] {
        let garnishes = IngredientMapper.ingredientsCatalog.filter { $0.type == .garnish }
        return garnishes.filter { detectedIngredients.contains($0.name) }
    }

    private func balanceIngredients(baseSpirit: String, modifiers: [String], sweeteners: [String], sours: [String], bitters: [String]) -> [(String, String?)] {
        var ingredientsWithMeasures: [(String, String?)] = []
        
        // Base spirit (usually 2 oz)
        ingredientsWithMeasures.append((baseSpirit, "2 oz"))
        
        // Modifier (usually 0.5 to 1 oz)
        if let modifier = modifiers.first {
            ingredientsWithMeasures.append((modifier, "1 oz"))
        }
        
        // Sweetener (usually 0.5 to 1 oz)
        if let sweetener = sweeteners.first {
            ingredientsWithMeasures.append((sweetener, "0.5 oz"))
        }
        
        // Sour (usually 0.75 oz)
        if let sour = sours.first {
            ingredientsWithMeasures.append((sour, "0.75 oz"))
        }
        
        // Bitters (usually a few dashes)
        for bitter in bitters.prefix(3) {  // Limit to a few types of bitters
            ingredientsWithMeasures.append((bitter, "2 dashes"))
        }
        
        return ingredientsWithMeasures
    }

    private func constructCocktailName(baseSpirit: String, modifiers: [String], sours: [String]) -> String {
        let primaryModifier = modifiers.first ?? ""
        let primarySour = sours.first ?? ""
        return "\(baseSpirit) \(primaryModifier) \(primarySour)".trimmingCharacters(in: .whitespaces)
    }

    private func constructInstructions(ingredients: [(String, String?)], garnish: String?) -> String {
        var steps: [String] = []

        steps.append("Add \(ingredients.map { $0.0 }.joined(separator: ", ")) to a shaker.")
        steps.append("Shake well with ice and strain into a chilled glass.")
        if let garnish = garnish {
            steps.append("Garnish with \(garnish).")
        } else {
            steps.append("Garnish as desired.")
        }

        return steps.joined(separator: " ")
    }
}
