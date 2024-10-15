//
//  FrameProcessor.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//


import AVFoundation
import Vision

class FrameProcessor {
    private let objectDetector: ObjectDetector

    init(objectDetector: ObjectDetector) {
        self.objectDetector = objectDetector
    }

    func process(_ pixelBuffer: CVPixelBuffer) {
        objectDetector.detect(pixelBuffer: pixelBuffer)
    }
}