//
//  InstructionsView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 18/10/2024.
//

import SwiftUI

struct InstructionsView: View {
    let instructions: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DisclosureGroup(
                content: {
                    if let instructions = instructions, !instructions.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(instructions.splitIntoSteps(), id: \.self) { step in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•")
                                        .font(.body)
                                        .foregroundColor(Color("PrimaryText"))
                                    Text(step)
                                        .font(.system(.body, design: .rounded))
                                        .foregroundColor(Color("PrimaryText"))
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    } else {
                        Text("No instructions available.")
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(Color("PrimaryText"))
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                    }
                },
                label: {
                    Text("Instructions")
                        .font(.system(.title3, design: .rounded))
                        .bold()
                        .foregroundColor(Color("SecondaryText"))
                }
            )
            .accentColor(Color("SecondaryText"))
            .padding(.vertical, 5)
        }
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
        .padding(.horizontal)
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView(instructions: "Shake well. Strain into a chilled cocktail glass. Garnish with a lime wheel.")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
