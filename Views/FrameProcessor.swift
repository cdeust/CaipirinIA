//
//  FrameProcessor.swift
//  CaipirinIA
//
//  Created by Clément Deust on 13/09/2024.
//

import AVFoundation
import Vision

class FrameProcessor {
    private let objectDetector: ObjectDetector

    init(objectDetector: ObjectDetector) {
        self.objectDetector = objectDetector
    }

    func process(_ sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        objectDetector.detect(pixelBuffer: pixelBuffer)
    }
}
