//
//  TitleModifier.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.titleFont)
            .foregroundColor(.primaryColor)
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(TitleModifier())
    }
}
