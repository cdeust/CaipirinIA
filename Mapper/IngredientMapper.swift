//
//  IngredientMapper.swift
//  CaipirinIA
//
//  Created by Clément Deust on 15/10/2024.
//

import Foundation

class IngredientMapper {
    // Dictionary of standard ingredient name to its alternative names
    private static let ingredientMapping: [String: [String]] = [
        // Base Spirits
        "Vodka": ["vodka", "vodka bottle", "absolut kurant", "absolut peppar", "absolut vodka", "absolut citron"],
        "Whiskey": ["whiskey", "whisky", "scotch whisky", "scotch", "bourbon", "irish whiskey", "jack daniels", "jim beam", "johnnie walker"],
        "Rum": ["rum", "rhum", "ron", "white rum", "dark rum", "anejo rum", "bacardi", "bacardi limon", "gold rum", "spiced rum", "pineapple rum", "blackstrap rum"],
        "Tequila": ["tequila", "mezcal", "gold tequila", "tequila rose", "illegal joven mezcal"],
        "Brandy": ["brandy", "cognac", "apple brandy", "apricot brandy", "peach brandy"],
        "Absinthe": ["absinthe"],
        "Schnapps": ["schnapps", "peach schnapps", "apple schnapps", "blackberry schnapps", "blueberry schnapps", "butterscotch schnapps"],
        "Champagne": ["champagne", "prosecco"],
        "Beer": ["beer", "ale", "lager", "corona", "guinness stout"],
        "Cider": ["cider", "apple cider"],
        "Wine": ["wine", "vin", "red wine", "white wine", "vin rouge", "vin blanc", "port", "ruby port", "madeira", "tawny port"],
        "Sake": ["sake"],
        "Pisco": ["pisco"],
        "Calvados": ["calvados"],
        "Aquavit": ["aquavit"],

        // Modifiers
        "Sweet Vermouth": ["vermouth", "dry vermouth", "sweet vermouth", "martini rosso", "rosso vermouth", "martini bianco", "martini extra dry", "dubonnet rouge", "dubonnet blanc", "lillet blanc", "cocchi americano"],
        "Triple Sec": ["triple sec", "cointreau", "orange liqueur", "grand marnier", "dry curacao", "blue curacao", "orange curacao"],
        "Amaretto": ["amaretto"],
        "Campari": ["campari"],
        "Aperol": ["aperol"],
        "Maraschino Liqueur": ["maraschino liqueur"],
        "Irish Cream Liqueur": ["baileys", "bailey's irish cream", "irish cream"],
        "Coffee Liqueur": ["kahlua", "coffee liqueur", "coffee brandy"],
        "Cherry Liqueur": ["cherry liqueur", "cherry heering", "cherry grenadine", "cherry juice"],
        "Peach Schnapps": ["peach schnapps", "peachtree schnapps"],
        "Frangelico": ["frangelico"],
        "Creme de Cassis": ["creme de cassis"],
        "Chambord": ["chambord raspberry liqueur", "chambord"],
        "Cynar": ["cynar"],
        "Averna": ["averna"],
        "Fernet": ["fernet-branca"],
        "Amaro Montenegro": ["amaro montenegro"],
        "Benedictine": ["benedictine"],

        // Sweeteners
        "Simple Syrup": ["simple syrup", "syrup", "sirop simple", "sugar syrup", "corn syrup"],
        "Honey Syrup": ["honey syrup", "honey", "sirop de miel"],
        "Maple Syrup": ["maple syrup", "sirop d'érable"],
        "Agave Syrup": ["agave syrup", "sirop d'agave"],
        "Grenadine": ["grenadine", "cherry grenadine"],
        "Orgeat Syrup": ["orgeat syrup"],
        "Falernum": ["falernum"],
        "Elderflower Syrup": ["elderflower syrup", "elderflower cordial"],
        "Ginger Syrup": ["ginger syrup"],

        // Sours
        "Lemon Juice": ["lemon juice", "lemon", "jus de citron", "fresh lemon juice", "lemon-lime", "lemon peel"],
        "Lime Juice": ["lime juice", "lime", "jus de lime", "fresh lime juice", "lime juice cordial", "lime peel", "limeade"],
        "Orange Juice": ["orange juice", "jus d'orange", "squeezed orange", "orange soda"],
        "Grapefruit Juice": ["grapefruit juice", "jus de pamplemousse"],
        "Pineapple Juice": ["pineapple juice", "jus d'ananas", "pineapple-orange-banana juice", "pineapple syrup"],
        "Cranberry Juice": ["cranberry juice", "jus de canneberge", "cranberry liqueur", "cranberry vodka"],
        "Pomegranate Juice": ["pomegranate juice", "jus de grenade"],

        // Bitters
        "Angostura Bitters": ["angostura bitters"],
        "Orange Bitters": ["orange bitters"],
        "Peychaud's Bitters": ["peychaud's bitters", "peychaud bitters"],
        "Chocolate Bitters": ["chocolate bitters"],
        "Coffee Bitters": ["coffee bitters"],
        "Peach Bitters": ["peach bitters"],

        // Mixers (Sodas)
        "Soda Water": ["club soda", "soda water", "eau gazeuse", "eau de seltz", "carbonated water", "carbonated soft drink"],
        "Tonic Water": ["tonic", "tonic water", "eau tonique"],
        "Ginger Beer": ["ginger beer", "bière au gingembre"],
        "Ginger Ale": ["ginger ale"],
        "Cola": ["cola", "coca-cola", "pepsi", "diet coke"],
        "Lemon-Lime Soda": ["sprite", "7up", "soda citron-lime", "lemon-lime soda", "mountain dew", "squirt"],
        "Root Beer": ["root beer", "bière de racine", "root beer schnapps"],
        "Cream Soda": ["cream soda"],

        // Dairy and Non-Dairy
        "Milk": ["milk", "lait"],
        "Cream": ["cream", "crème", "half and half", "heavy cream", "whipped cream", "light cream", "cream soda", "whipping cream", "condensed milk", "evaporated milk"],
        "Coconut Milk": ["coconut milk", "lait de coco", "cream of coconut", "coconut cream"],
        "Almond Milk": ["almond milk", "lait d'amande"],
        "Soy Milk": ["soy milk", "soya milk"],

        // Garnishes
        "Mint": ["mint", "menthe", "fresh mint", "mint syrup"],
        "Lime Wedge": ["lime wedge", "quartier de lime"],
        "Lemon Twist": ["lemon twist", "zeste de citron"],
        "Orange Slice": ["orange slice", "tranche d'orange", "orange spiral", "orange peel"],
        "Cherry": ["cherry", "cerise", "maraschino cherry"],
        "Olive": ["olive", "green olives"],
        "Cucumber Slice": ["cucumber slice", "tranche de concombre", "cucumber"],
        "Rosemary Sprig": ["rosemary sprig", "brin de romarin", "rosemary", "rosemary syrup"],
        "Cinnamon Stick": ["cinnamon stick", "bâton de cannelle"],
        "Sugar Rim": ["sugar rim", "bordure de sucre"],
        "Salt Rim": ["salt rim", "bordure de sel"],
        "Chocolate Shavings": ["chocolate shavings", "copeaux de chocolat", "chocolate sauce", "salted chocolate"],

        // Fruits and Vegetables
        "Strawberry": ["strawberry", "fraise", "strawberries", "strawberry juice", "strawberry schnapps", "strawberry liqueur"],
        "Banana": ["banana", "banane", "banana liqueur", "banana rum", "banana syrup"],
        "Blueberry": ["blueberries", "blueberry", "bleuets"],
        "Blackberry": ["blackberries", "blackberry", "mûre", "blackberry brandy", "blackberry schnapps"],
        "Raspberry": ["raspberry", "framboise", "raspberry juice", "raspberry schnapps", "raspberry liqueur", "raspberry cordial"],
        "Peach": ["peach", "pêche", "peach schnapps", "peach juice", "peach brandy", "peach nectar", "peach vodka"],
        "Pineapple": ["pineapple", "ananas", "pineapple vodka"],
        "Watermelon": ["watermelon", "pastèque", "watermelon schnapps"],
        "Orange": ["orange", "blood orange"],
        "Lemon": ["lemon", "citron"],
        "Lime": ["lime"],

        // Miscellaneous
        "Egg White": ["egg white", "blanc d'œuf"],
        "Egg Yolk": ["egg yolk", "jaune d'œuf"],
        "Egg": ["egg", "egg yolk"],
        "Sugar": ["sugar", "sucre", "granulated sugar", "brown sugar", "powdered sugar"],
        "Vanilla Extract": ["vanilla extract", "extrait de vanille", "vanilla syrup", "vanilla schnapps"],
        "Nutmeg": ["nutmeg", "muscade"],
        "Cinnamon": ["cinnamon", "cannelle"],
        "Ice": ["ice", "glace"],
        "Chocolate": ["chocolate", "plain chocolate", "chocolate ice cream", "chocolate milk"],
        "Rosewater": ["rosewater", "sirup of roses"]
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
        Ingredient(name: "Añejo Rum", type: .baseSpirit),
        Ingredient(name: "Canadian Whisky", type: .baseSpirit),
        Ingredient(name: "Spiced Rum", type: .baseSpirit),
        Ingredient(name: "Gold Tequila", type: .baseSpirit),
        Ingredient(name: "Cachaca", type: .baseSpirit),
        Ingredient(name: "Dark Rum", type: .baseSpirit),
        Ingredient(name: "White Rum", type: .baseSpirit),

        // Modifiers
        Ingredient(name: "Sweet Vermouth", type: .modifier),
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
        Ingredient(name: "Frangelico", type: .modifier),
        Ingredient(name: "Chambord", type: .modifier),
        Ingredient(name: "Creme de Cassis", type: .modifier),
        Ingredient(name: "Schnapps", type: .modifier),
        Ingredient(name: "Advocaat", type: .modifier),
        Ingredient(name: "Benedictine", type: .modifier),
        Ingredient(name: "Cherry Liqueur", type: .modifier),
        Ingredient(name: "Peach Schnapps", type: .modifier),
        Ingredient(name: "Averna", type: .modifier),
        Ingredient(name: "Fernet-Branca", type: .modifier),
        Ingredient(name: "Pernod", type: .modifier),
        Ingredient(name: "Amaro Montenegro", type: .modifier),

        // Sweeteners
        Ingredient(name: "Simple Syrup", type: .sweetener),
        Ingredient(name: "Honey Syrup", type: .sweetener),
        Ingredient(name: "Maple Syrup", type: .sweetener),
        Ingredient(name: "Agave Syrup", type: .sweetener),
        Ingredient(name: "Grenadine", type: .sweetener),
        Ingredient(name: "Orgeat Syrup", type: .sweetener),
        Ingredient(name: "Falernum", type: .sweetener),
        Ingredient(name: "Elderflower Syrup", type: .sweetener),
        Ingredient(name: "Ginger Syrup", type: .sweetener),
        Ingredient(name: "Vanilla Syrup", type: .sweetener),

        // Sours
        Ingredient(name: "Lemon Juice", type: .sour),
        Ingredient(name: "Lime Juice", type: .sour),
        Ingredient(name: "Orange Juice", type: .sour),
        Ingredient(name: "Grapefruit Juice", type: .sour),
        Ingredient(name: "Pineapple Juice", type: .sour),
        Ingredient(name: "Cranberry Juice", type: .sour),
        Ingredient(name: "Pomegranate Juice", type: .sour),
        Ingredient(name: "Passion Fruit Juice", type: .sour),
        Ingredient(name: "Yuzu Juice", type: .sour),
        Ingredient(name: "Fresh Lemon Juice", type: .sour),
        Ingredient(name: "Apple Juice", type: .sour),
        Ingredient(name: "Apricot Nectar", type: .sour),

        // Bitters
        Ingredient(name: "Angostura Bitters", type: .bitter),
        Ingredient(name: "Orange Bitters", type: .bitter),
        Ingredient(name: "Peychaud's Bitters", type: .bitter),
        Ingredient(name: "Chocolate Bitters", type: .bitter),
        Ingredient(name: "Coffee Bitters", type: .bitter),
        Ingredient(name: "Peach Bitters", type: .bitter),
        Ingredient(name: "Lavender Bitters", type: .bitter),

        // Mixers (Sodas)
        Ingredient(name: "Soda Water", type: .mixer),
        Ingredient(name: "Tonic Water", type: .mixer),
        Ingredient(name: "Ginger Beer", type: .mixer),
        Ingredient(name: "Ginger Ale", type: .mixer),
        Ingredient(name: "Cola", type: .mixer),
        Ingredient(name: "Lemon-Lime Soda", type: .mixer),
        Ingredient(name: "Root Beer", type: .mixer),
        Ingredient(name: "Cream Soda", type: .mixer),
        Ingredient(name: "Coca-Cola", type: .mixer),
        Ingredient(name: "Fanta", type: .mixer),
        Ingredient(name: "Sprite", type: .mixer),

        // Dairy and Non-Dairy
        Ingredient(name: "Milk", type: .dairy),
        Ingredient(name: "Cream", type: .dairy),
        Ingredient(name: "Coconut Milk", type: .dairy),
        Ingredient(name: "Soy Milk", type: .dairy),
        Ingredient(name: "Whipped Cream", type: .dairy),
        Ingredient(name: "Half-and-half", type: .dairy),

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
        Ingredient(name: "Orange Peel", type: .garnish),
        Ingredient(name: "Sugar Rim", type: .garnish),
        Ingredient(name: "Salt Rim", type: .garnish),
        Ingredient(name: "Chocolate Shavings", type: .garnish),
        Ingredient(name: "Pineapple Leaf", type: .garnish),

        // Fruits and Vegetables
        Ingredient(name: "Strawberry", type: .fruit),
        Ingredient(name: "Banana", type: .fruit),
        Ingredient(name: "Blueberry", type: .fruit),
        Ingredient(name: "Blackberry", type: .fruit),
        Ingredient(name: "Raspberry", type: .fruit),
        Ingredient(name: "Peach", type: .fruit),
        Ingredient(name: "Pineapple", type: .fruit),
        Ingredient(name: "Watermelon", type: .fruit),
        Ingredient(name: "Orange", type: .fruit),
        Ingredient(name: "Lemon", type: .fruit),
        Ingredient(name: "Lime", type: .fruit),
        Ingredient(name: "Grapes", type: .fruit),
        Ingredient(name: "Cucumber", type: .fruit),
        Ingredient(name: "Apple", type: .fruit),
        Ingredient(name: "Passion Fruit", type: .fruit),
        Ingredient(name: "Pomegranate", type: .fruit),
        Ingredient(name: "Cherry", type: .fruit),

        // Miscellaneous
        Ingredient(name: "Egg White", type: .miscellaneous),
        Ingredient(name: "Egg Yolk", type: .miscellaneous),
        Ingredient(name: "Egg", type: .miscellaneous),
        Ingredient(name: "Sugar", type: .miscellaneous),
        Ingredient(name: "Vanilla Extract", type: .miscellaneous),
        Ingredient(name: "Nutmeg", type: .miscellaneous),
        Ingredient(name: "Cinnamon", type: .miscellaneous),
        Ingredient(name: "Ice", type: .miscellaneous),
        Ingredient(name: "Chocolate", type: .miscellaneous),
        Ingredient(name: "Rosewater", type: .miscellaneous)
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
