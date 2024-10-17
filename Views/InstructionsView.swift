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
        VStack(alignment: .leading, spacing: 10) {
            Text("Instructions:")
                .font(.headline)
            
            if let instructions = instructions, !instructions.isEmpty {
                Text(instructions)
                    .padding(.leading)
                    .font(.subheadline)
                    .foregroundColor(Color("PrimaryText"))
            } else {
                Text("No instructions available.")
                    .font(.body)
                    .foregroundColor(Color("PrimaryText"))
                    .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }
}
