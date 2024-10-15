//
//  CircleButton.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CircleButton: View {
    let iconName: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.green)
                .frame(width: 70, height: 70)
                .shadow(radius: 5)
            Image(systemName: iconName)
                .foregroundColor(.white)
                .font(.largeTitle)
        }
    }
}
