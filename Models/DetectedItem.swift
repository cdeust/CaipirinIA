//
//  Models.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import Foundation

struct DetectedItem: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let confidence: Float
    let boundingBox: CGRect
}
