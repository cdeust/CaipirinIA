//
//  IngredientMapper.swift
//  CaipirinIA
//
//  Created by Clément Deust on 13/09/2024.
//

import Foundation

class IngredientMapper {
    // Dictionary of standard ingredient name to its alternative names
    private static let ingredientMapping: [String: [String]] = [
        // Base Spirits
        "Vodka": ["vodka", "vodka bottle"],
        "Whiskey": ["whiskey", "whisky", "scotch whisky", "scotch", "bourbon"],
        "Rum": ["rum", "rhum", "ron", "white rum", "dark rum"],
        "Tequila": ["tequila", "mezcal"],
        "Brandy": ["brandy", "cognac"],
        "Absinthe": ["absinthe"],
        "Schnapps": ["schnapps"],
        "Champagne": ["champagne"],
        "Beer": ["beer", "bière"],
        "Cider": ["cider", "cidre"],
        "Wine": ["wine", "vin", "red wine", "white wine", "vin rouge", "vin blanc"],

        // Modifiers
        "Vermouth": ["vermouth", "dry vermouth", "sweet vermouth"],
        "Triple Sec": ["triple sec", "cointreau", "orange liqueur"],
        "Curacao": ["blue curacao", "curacao"],
        "Amaretto": ["amaretto"],
        "Campari": ["campari"],
        "Aperol": ["aperol"],
        "Maraschino Liqueur": ["maraschino liqueur"],
        "Irish Cream Liqueur": ["baileys", "bailey's irish cream", "irish cream"],
        "Coffee Liqueur": ["kahlua", "coffee liqueur"],
        "Grand Marnier": ["grand marnier"],
        "Cherry Liqueur": ["cherry liqueur"],
        "Peach Schnapps": ["peach schnapps"],

        // Sweeteners
        "Simple Syrup": ["simple syrup", "syrup", "sirop simple"],
        "Honey Syrup": ["honey syrup", "honey", "sirop de miel"],
        "Maple Syrup": ["maple syrup", "sirop d'érable"],
        "Agave Syrup": ["agave syrup", "sirop d'agave"],
        "Grenadine": ["grenadine"],
        "Orgeat Syrup": ["orgeat syrup"],
        "Falernum": ["falernum"],

        // Sours
        "Lemon Juice": ["lemon juice", "lemon", "jus de citron"],
        "Lime Juice": ["lime juice", "lime", "jus de lime"],
        "Orange Juice": ["orange juice", "jus d'orange"],
        "Grapefruit Juice": ["grapefruit juice", "jus de pamplemousse"],
        "Pineapple Juice": ["pineapple juice", "jus d'ananas"],
        "Cranberry Juice": ["cranberry juice", "jus de canneberge"],
        "Pomegranate Juice": ["pomegranate juice", "jus de grenade"],

        // Bitters
        "Angostura Bitters": ["angostura bitters"],
        "Orange Bitters": ["orange bitters"],
        "Peychaud's Bitters": ["peychaud's bitters"],
        "Chocolate Bitters": ["chocolate bitters"],
        "Coffee Bitters": ["coffee bitters"],

        // Mixers (Sodas)
        "Soda Water": ["club soda", "soda water", "eau gazeuse", "eau de seltz"],
        "Tonic Water": ["tonic", "tonic water", "eau tonique"],
        "Ginger Beer": ["ginger beer", "bière au gingembre"],
        "Ginger Ale": ["ginger ale"],
        "Cola": ["cola", "coca-cola", "pepsi"],
        "Lemon-Lime Soda": ["sprite", "7up", "soda citron-lime"],
        "Citrus Soda": ["mountain dew", "soda citrus"],
        "Root Beer": ["root beer", "bière de racine"],
        "Cream Soda": ["cream soda"],

        // Dairy and Non-Dairy
        "Milk": ["milk", "lait"],
        "Cream": ["cream", "crème", "half and half"],
        "Coconut Milk": ["coconut milk", "lait de coco"],
        "Almond Milk": ["almond milk", "lait d'amande"],
        "Evaporated Milk": ["evaporated milk", "lait évaporé"],

        // Garnishes
        "Mint": ["mint", "menthe"],
        "Lime Wedge": ["lime wedge", "quartier de lime"],
        "Lemon Twist": ["lemon twist", "zeste de citron"],
        "Orange Slice": ["orange slice", "tranche d'orange"],
        "Cherry": ["cherry", "cerise", "maraschino cherry"],
        "Olive": ["olive"],
        "Cucumber Slice": ["cucumber slice", "tranche de concombre"],
        "Rosemary Sprig": ["rosemary sprig", "brin de romarin"],
        "Cinnamon Stick": ["cinnamon stick", "bâton de cannelle"],
        "Sugar Rim": ["sugar rim", "bordure de sucre"],
        "Salt Rim": ["salt rim", "bordure de sel"],
        "Chocolate Shavings": ["chocolate shavings", "copeaux de chocolat"],

        // Fruits and Vegetables
        "Strawberry": ["strawberry", "fraise"],
        "Banana": ["banana", "banane"],
        "Blueberry": ["blueberries", "blueberry", "bleuets"],
        "Blackberry": ["blackberries", "blackberry", "mûre"],
        "Raspberry": ["raspberry", "framboise"],
        "Cucumber": ["cucumber", "concombre"],
        "Pineapple": ["pineapple", "ananas"],
        "Peach": ["peach", "pêche"],
        "Watermelon": ["watermelon", "pastèque"],
        "Orange": ["orange"],
        "Lemon": ["lemon", "citron"],
        "Lime": ["lime"],

        // Miscellaneous
        "Egg White": ["egg white", "blanc d'œuf"],
        "Egg Yolk": ["egg yolk", "jaune d'œuf"],
        "Sugar": ["sugar", "sucre"],
        "Powdered Sugar": ["powdered sugar", "sucre en poudre"],
        "Vanilla Extract": ["vanilla extract", "extrait de vanille"],
        "Nutmeg": ["nutmeg", "muscade"],
        "Cinnamon": ["cinnamon", "cannelle"],
        "Ice": ["ice", "glace"]
    ]

    static let ingredientsCatalog: [Ingredient] = [
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

    // Function to map a single ingredient to the correct one
    static func map(_ ingredient: String) -> String {
        // First check if the ingredient exists directly in the catalog
        if ingredientsCatalog.contains(where: { $0.name.caseInsensitiveCompare(ingredient) == .orderedSame }) {
            return ingredient // If there's an exact match, return the original input
        }

        // Otherwise, check the ingredient mapping dictionary
        for (standardIngredient, variations) in ingredientMapping {
            if variations.contains(ingredient.lowercased()) {
                return standardIngredient // Return the standard ingredient name if a match is found
            }
        }

        // If no match is found, return the original input
        return ingredient
    }

    // Function to map an array of ingredients
    static func mapIngredients(_ ingredients: [String]) -> [String] {
        return ingredients.map { map($0) }
    }
}
