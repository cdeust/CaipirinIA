//
//  CGImage+Resized.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import Foundation

extension String {
    func splitIntoSteps() -> [String] {
        let delimiters: Set<Character> = [".", "!", "?", "\n"]
        
        let rawSteps = self.split { delimiters.contains($0) }
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        return rawSteps.map { step in
            step.hasSuffix(".") ? step : step + "."
        }
    }
}
