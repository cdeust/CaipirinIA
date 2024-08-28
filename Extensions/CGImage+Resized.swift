//
//  CGImage+Resized.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import Foundation
import UIKit

extension CGImage {
    func resized(to size: CGSize) -> CGImage? {
        let width = Int(size.width)
        let height = Int(size.height)
        let bitsPerComponent = self.bitsPerComponent
        let bytesPerRow = width * 4
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = self.bitmapInfo.rawValue

        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else {
            return nil
        }

        context.interpolationQuality = .high
        context.draw(self, in: CGRect(origin: .zero, size: size))

        return context.makeImage()
    }
}
