//
//  Config.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//


import SwiftUI

struct Config {
    struct API {
        static let cocktailDBKey = "\(Configuration.apiKey)"
        static let baseURL = "https://www.thecocktaildb.com/api/json/v2/"
    }

    struct Colors {
        static let primary = Color("PrimaryColor")
        static let secondary = Color("SecondaryColor")
        static let background = Color("BackgroundColor")
    }

    struct Fonts {
        static let title = Font.system(size: 24, weight: .bold)
        static let body = Font.system(size: 16)
    }

    enum Constants {
        static let defaultTimeout: TimeInterval = 30
    }
}
