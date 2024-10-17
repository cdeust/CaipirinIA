//
//  ShapeStyleModifier.swift
//  CaipirinIA
//
//  Created by Clément Deust on 17/10/2024.
//

import SwiftUI

enum ShapeType {
    case circle
    case roundedRectangle(cornerRadius: CGFloat)
    case rectangle
}

struct ShapeStyleModifier: ViewModifier {
    let shapeType: ShapeType
    
    func body(content: Content) -> some View {
        switch shapeType {
        case .circle:
            content
                .clipShape(Circle())
        case .roundedRectangle(let cornerRadius):
            content
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        case .rectangle:
            content
                .clipShape(Rectangle())
        }
    }
}

extension View {
    func applyShape(_ shapeType: ShapeType) -> some View {
        self.modifier(ShapeStyleModifier(shapeType: shapeType))
    }
}
