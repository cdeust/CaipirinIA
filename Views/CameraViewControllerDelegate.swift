//
//  CameraViewControllerDelegate.swift
//  CaipirinIA
//
//  Created by Clément Deust on 13/09/2024.
//

import Foundation
import UIKit

protocol CameraViewControllerDelegate: AnyObject {
    func cameraViewController(_ controller: CameraViewController, didCaptureFrame pixelBuffer: CVPixelBuffer)
}

