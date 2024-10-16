//
//  ShakeEffect.swift
//  CaipirinIA
//
//  Created by Clément Deust on 16/10/2024.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var shakes: CGFloat = 0
    var amplitude: CGFloat = 10
    var frequency: CGFloat = 3

    var animatableData: CGFloat {
        get { shakes }
        set { shakes = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = amplitude * sin(shakes * .pi * frequency)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}
