//
//  FrameProcessor.swift
//  CaipirinIA
//
//  Created by Clément Deust on 13/09/2024.
//

import AVFoundation
import Vision

class FrameProcessor {
    private var lastProcessedTime = CMTime()  // For frame rate throttling
    private let desiredFrameRate: Int32  // Frame rate for detection
    private let objectDetector: ObjectDetector
    
    init(desiredFrameRate: Int32 = 15, objectDetector: ObjectDetector) {
        self.desiredFrameRate = desiredFrameRate
        self.objectDetector = objectDetector
    }

    func process(_ sampleBuffer: CMSampleBuffer) {
        let currentTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let elapsedTime = currentTime - lastProcessedTime

        if elapsedTime >= CMTimeMake(value: 1, timescale: desiredFrameRate) {
            lastProcessedTime = currentTime

            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            objectDetector.detect(in: pixelBuffer)
        }
    }
}
