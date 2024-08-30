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
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Instructions")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .center)

            // Split instructions into steps
            ForEach(instructions.split(separator: ".").filter { !$0.isEmpty }, id: \.self) { step in
                Text(step.trimmingCharacters(in: .whitespacesAndNewlines) + ".")
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemGray5).opacity(0.8))
        )
        .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
        .frame(maxWidth: .infinity) // Ensure the view takes full width
    }
}

struct CocktailInstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CocktailInstructionsView(instructions: "Shake all ingredients with ice and strain into a chilled cocktail glass. Garnish with a lime wedge. Serve immediately.")
                .environmentObject(AppState())
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .padding()

            CocktailInstructionsView(instructions: "Shake all ingredients with ice and strain into a chilled cocktail glass. Garnish with a lime wedge. Serve immediately.")
                .environmentObject(AppState())
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
