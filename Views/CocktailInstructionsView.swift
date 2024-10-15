//
//  CocktailInstructionsView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct CocktailInstructionsView: View {
    let instructions: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Instructions:")
                .font(.title2)
                .bold()
                .padding(.bottom, 5)

            Text(instructions)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}
