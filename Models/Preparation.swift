//
//  Preparation.swift
//  CaipirinIA
//
//  Created by Clément Deust on 15/10/2024.
//

import SwiftUI

struct Preparation: Identifiable, Codable {
    let id: UUID
    let cocktailName: String
    let datePrepared: Date
    let steps: [String]
}
