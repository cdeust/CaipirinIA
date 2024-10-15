//
//  BoundingBox.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI
import Vision

struct BoundingBoxView: Shape {
    let boundingBox: CGRect
    let geometry: GeometryProxy

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        let boxWidth = boundingBox.width * width
        let boxHeight = boundingBox.height * height
        let boxX = boundingBox.minX * width
        let boxY = (1 - boundingBox.maxY) * height // Invert Y axis

        path.addRect(CGRect(x: boxX, y: boxY, width: boxWidth, height: boxHeight))
        return path
    }
}
