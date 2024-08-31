//
//  Catalog.swift
//  CaipirinIA
//
//  Created by Clément Deust on 31/08/2024.
//

import Foundation

let ingredientsCatalog: [Ingredient] = [
    // Base Spirits
    Ingredient(name: "Vodka", type: .baseSpirit),
    Ingredient(name: "Gin", type: .baseSpirit),
    Ingredient(name: "Rum", type: .baseSpirit),
    Ingredient(name: "Tequila", type: .baseSpirit),
    Ingredient(name: "Whiskey", type: .baseSpirit),
    Ingredient(name: "Bourbon", type: .baseSpirit),
    Ingredient(name: "Scotch", type: .baseSpirit),
    Ingredient(name: "Brandy", type: .baseSpirit),
    Ingredient(name: "Cognac", type: .baseSpirit),
    Ingredient(name: "Mezcal", type: .baseSpirit),
    Ingredient(name: "Absinthe", type: .baseSpirit),
    Ingredient(name: "Pisco", type: .baseSpirit),
    Ingredient(name: "Calvados", type: .baseSpirit),
    Ingredient(name: "Sake", type: .baseSpirit),

    // Modifiers
    Ingredient(name: "Vermouth", type: .modifier),
    Ingredient(name: "Triple Sec", type: .modifier),
    Ingredient(name: "Cointreau", type: .modifier),
    Ingredient(name: "Amaretto", type: .modifier),
    Ingredient(name: "Campari", type: .modifier),
    Ingredient(name: "Aperol", type: .modifier),
    Ingredient(name: "Maraschino Liqueur", type: .modifier),
    Ingredient(name: "Kahlua", type: .modifier),
    Ingredient(name: "Baileys", type: .modifier),
    Ingredient(name: "Grand Marnier", type: .modifier),
    Ingredient(name: "Blue Curacao", type: .modifier),
    Ingredient(name: "Dry Vermouth", type: .modifier),
    Ingredient(name: "Sweet Vermouth", type: .modifier),
    Ingredient(name: "St. Germain", type: .modifier),
    Ingredient(name: "Lillet Blanc", type: .modifier),
    Ingredient(name: "Creme de Cassis", type: .modifier),
    Ingredient(name: "Frangelico", type: .modifier),
    Ingredient(name: "Chambord", type: .modifier),

    // Sweeteners
    Ingredient(name: "Simple Syrup", type: .sweetener),
    Ingredient(name: "Honey Syrup", type: .sweetener),
    Ingredient(name: "Maple Syrup", type: .sweetener),
    Ingredient(name: "Agave Syrup", type: .sweetener),
    Ingredient(name: "Grenadine", type: .sweetener),
    Ingredient(name: "Orgeat Syrup", type: .sweetener),
    Ingredient(name: "Falernum", type: .sweetener),
    Ingredient(name: "Elderflower Syrup", type: .sweetener),
    Ingredient(name: "Vanilla Syrup", type: .sweetener),
    Ingredient(name: "Ginger Syrup", type: .sweetener),

    // Sours
    Ingredient(name: "Lemon Juice", type: .sour),
    Ingredient(name: "Lime Juice", type: .sour),
    Ingredient(name: "Orange Juice", type: .sour),
    Ingredient(name: "Grapefruit Juice", type: .sour),
    Ingredient(name: "Pineapple Juice", type: .sour),
    Ingredient(name: "Cranberry Juice", type: .sour),
    Ingredient(name: "Pomegranate Juice", type: .sour),
    Ingredient(name: "Tamarind Juice", type: .sour),
    Ingredient(name: "Passion Fruit Juice", type: .sour),
    Ingredient(name: "Yuzu Juice", type: .sour),

    // Bitters
    Ingredient(name: "Angostura Bitters", type: .bitter),
    Ingredient(name: "Orange Bitters", type: .bitter),
    Ingredient(name: "Peychaud's Bitters", type: .bitter),
    Ingredient(name: "Chocolate Bitters", type: .bitter),
    Ingredient(name: "Coffee Bitters", type: .bitter),
    Ingredient(name: "Lavender Bitters", type: .bitter),
    Ingredient(name: "Grapefruit Bitters", type: .bitter),
    Ingredient(name: "Celery Bitters", type: .bitter),
    Ingredient(name: "Peach Bitters", type: .bitter),

    // Garnishes
    Ingredient(name: "Mint", type: .garnish),
    Ingredient(name: "Lime Wedge", type: .garnish),
    Ingredient(name: "Lemon Twist", type: .garnish),
    Ingredient(name: "Orange Slice", type: .garnish),
    Ingredient(name: "Cherry", type: .garnish),
    Ingredient(name: "Olive", type: .garnish),
    Ingredient(name: "Cucumber Slice", type: .garnish),
    Ingredient(name: "Rosemary Sprig", type: .garnish),
    Ingredient(name: "Cinnamon Stick", type: .garnish),
    Ingredient(name: "Sugar Rim", type: .garnish),
    Ingredient(name: "Salt Rim", type: .garnish),
    Ingredient(name: "Chocolate Shavings", type: .garnish),
    Ingredient(name: "Pineapple Leaf", type: .garnish),
    Ingredient(name: "Edible Flower", type: .garnish),
    Ingredient(name: "Star Anise", type: .garnish),
    Ingredient(name: "Orange Peel", type: .garnish)
]
