//
//  StarAnimator.swift
//  CaipirinIA
//
//  Created by Clément Deust on 16/09/2024.
//

import UIKit

class StarAnimator {
    private let overlayLayer: CALayer
    private let emitterLayer: CAEmitterLayer

    init(overlayLayer: CALayer) {
        self.overlayLayer = overlayLayer

        emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .point
        emitterLayer.emitterMode = .outline
        overlayLayer.addSublayer(emitterLayer)
    }

    func showStars(around rect: CGRect, starCount: Int = 5, animationDuration: CFTimeInterval = 1.5) {
        emitterLayer.emitterPosition = CGPoint(x: rect.midX, y: rect.midY)

        let cell = CAEmitterCell()
        cell.contents = UIImage(systemName: "star.fill")?.cgImage
        cell.birthRate = Float(starCount) / Float(animationDuration)
        cell.lifetime = Float(animationDuration)
        cell.velocity = 50
        cell.velocityRange = 20
        cell.scale = 0.1
        cell.scaleRange = 0.05
        cell.emissionRange = CGFloat.pi * 2

        emitterLayer.emitterCells = [cell]

        // Remove emitter after duration
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.emitterLayer.emitterCells = nil
        }
    }
}
