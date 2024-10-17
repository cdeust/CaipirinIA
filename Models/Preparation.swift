//
//  Preparation.swift
//  CaipirinIA
//
//  Created by Clément Deust on 15/10/2024.
//

import SwiftUI

struct Preparation: Identifiable, Codable {
    let id: UUID
    let cocktailId: String
    let cocktailName: String
    let datePrepared: Date
    let steps: [String]
    let imageName: URL?
    
    // Additional fields to match with Cocktail model
    let strCategory: String?
    let strAlcoholic: String?
    let strGlass: String?
    let strInstructions: String?
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
    let strDrinkThumb: String? // Thumbnail image
    
    let source: CocktailSource
}
