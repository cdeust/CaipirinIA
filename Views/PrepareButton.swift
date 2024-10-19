//
//  PrepareButton.swift
//  CaipirinIA
//
//  Created by Clément Deust on 18/10/2024.
//

import SwiftUI

struct PrepareButton: View {
    let cocktail: Cocktail?
    
    var body: some View {
        if let cocktail = cocktail {
            NavigationLink(destination: PreparationStepsView(cocktail: cocktail)) {
                Text("Prepare")
                    .font(.system(.headline, design: .rounded))  // Modern font for a cleaner design
                    .foregroundColor(.white)  // Better contrast with the background
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(  // Gradient for the button background
                            gradient: Gradient(colors: [Color.accentColor, Color.accentColor]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)  // Rounded corners for a modern look
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 5)  // Softer, larger shadow for depth
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
            }
        }
    }
}
