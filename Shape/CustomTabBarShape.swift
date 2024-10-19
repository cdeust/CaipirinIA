//
//  CustomTabBarShape.swift
//  CaipirinIA
//
//  Created by Clément Deust on 19/10/2024.
//

import SwiftUI

struct CustomTabBarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Start from the left
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width * 0.3, y: 0))

        // Create the circular cutout in the center of the bar
        path.addArc(
            center: CGPoint(x: rect.width / 2, y: 0),
            radius: 40, // Cutout radius
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )

        path.addLine(to: CGPoint(x: rect.width * 0.7, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))

        return path
    }
}
