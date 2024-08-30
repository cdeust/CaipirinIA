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
        VStack(alignment: .leading, spacing: 16) {
            Text("Instructions")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .center)

            Text(instructions)
                .font(.body)
                .foregroundColor(.primary)
                .padding(.vertical)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.teal.opacity(0.2), Color(UIColor.systemBackground)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(12)
        .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct CocktailInstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        CocktailInstructionsView(instructions: "Shake all ingredients with ice and strain into a chilled cocktail glass.")
            .environmentObject(AppState())
            .preferredColorScheme(.light) // Add this line to preview in light mode
        CocktailInstructionsView(instructions: "Shake all ingredients with ice and strain into a chilled cocktail glass.")
            .environmentObject(AppState())
            .preferredColorScheme(.dark) // Add this line to preview in dark mode
    }
}
