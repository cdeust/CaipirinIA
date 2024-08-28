//
//  Data+ToArray.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import Foundation

extension Data {
    func toArray<T>(type: T.Type) -> [T] {
        withUnsafeBytes { buffer in
            [T](buffer.bindMemory(to: T.self))
        }
    }
}
