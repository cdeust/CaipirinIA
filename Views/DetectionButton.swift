//
//  DetectionButton 2.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct DetectionButton: View {
    @ObservedObject var viewModel: CameraViewModel

    var body: some View {
        Button(action: {
            viewModel.processDetection()
        }) {
            ZStack {
                Circle()
                    .fill(Color("AccentColor"))
                    .frame(width: 70, height: 70)
                    .shadow(radius: 5)
                Text(viewModel.detectedItems.isEmpty ? "Detect" : "Go")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
        .padding(.bottom, 30)
    }
}
