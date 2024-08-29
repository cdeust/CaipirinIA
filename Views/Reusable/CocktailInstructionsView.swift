//
//  CocktailInstructionsView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import SwiftUI

struct CocktailInstructionsView: View {
    @EnvironmentObject var appState: AppState
    var instructions: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Instructions")
                .font(.headline)
                .padding(.bottom, 4)

            Text(instructions)
        }
    }
}
