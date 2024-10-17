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
                    .font(.headline)
                    .foregroundColor(Color("PrimaryText"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("BackgroundStart"))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.top, 20)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal, 20)
        }
    }
}
