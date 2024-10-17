//
//  Config.swift
//  CaipirinIA
//
//  Created by Clément Deust on 11/10/2024.
//

import Foundation

struct Configuration {
    static let apiKey: String = {
        if let url = Bundle.main.url(forResource: "Config", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
           let dict = plist as? [String: Any],
           let key = dict["API_KEY"] as? String {
            return key
        }
        fatalError("API_KEY not found in Config.plist")
    }()
    
    static let openApiKey: String = {
        if let url = Bundle.main.url(forResource: "Config", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
           let dict = plist as? [String: Any],
           let key = dict["OPEN_API_KEY"] as? String {
            return key
        }
        fatalError("OPEN_API_KEY not found in Config.plist")
    }()
    
    static let pexelsApiKey: String = {
        if let url = Bundle.main.url(forResource: "Config", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
           let dict = plist as? [String: Any],
           let key = dict["PEXELS_API_KEY"] as? String {
            return key
        }
        fatalError("OPEN_API_KEY not found in Config.plist")
    }()
}
