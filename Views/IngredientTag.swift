//
//  IngredientTag.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct IngredientTag: View {
    var ingredient: DetectedItem
    @State private var shake: CGFloat = 0
    @State private var isVisible: Bool = false
    
    var body: some View {
        Text(ingredient.name)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color.green.opacity(0.7))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .modifier(ShakeEffect(shakes: shake))
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(.easeIn(duration: 0.5)) {
                    self.isVisible = true
                }
                // Trigger shake animation after fade-in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(Animation.linear(duration: 0.3).repeatCount(1, autoreverses: false)) {
                        self.shake = 1
                    }
                }
            }
    }
}
