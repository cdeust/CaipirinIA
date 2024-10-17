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

            DisclosureGroup("View Steps") {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(instructions.splitIntoSteps(), id: \.self) { step in
                        HStack(alignment: .top, spacing: 5) {
                            Text("•")
                                .font(.body)
                                .foregroundColor(Color("PrimaryText"))
                            Text(step)
                                .font(.body)
                                .foregroundColor(Color("PrimaryText"))
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.leading, 5)
                    }
                }
                .padding(.top, 5)
            }
            .padding(.top, 10)
            .accentColor(Color("PrimaryText"))
        }
    }
}
