//
//  CircularButtonModifier.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CircularButtonModifier: ViewModifier {
    var backgroundColor: Color
    var foregroundColor: Color
    var shadowColor: Color
    var shadowRadius: CGFloat
    var size: CGFloat
    var isPressed: Bool

    func body(content: Content) -> some View {
        content
            .font(.system(size: size * 0.3, weight: .medium))
            .foregroundColor(foregroundColor)
            .padding(size * 0.2)
            .background(backgroundColor)
            .clipShape(Circle())
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 2)
            .scaleEffect(isPressed ? 0.95 : 1.0)
    }
}

extension View {
    func circularButtonStyle(
        backgroundColor: Color,
        foregroundColor: Color,
        shadowColor: Color = Color.black.opacity(0.2),
        shadowRadius: CGFloat = 5,
        size: CGFloat = 24,
        isPressed: Bool = false
    ) -> some View {
        self.modifier(
            CircularButtonModifier(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                shadowColor: shadowColor,
                shadowRadius: shadowRadius,
                size: size,
                isPressed: isPressed
            )
        )
    }
}
