//
//  ErrorView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import SwiftUI

struct ErrorView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .multilineTextAlignment(.center)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red.opacity(0.8))
            )
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            .padding(.horizontal)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ErrorView(message: "Something went wrong. Please try again.")
                .preferredColorScheme(.light)
            
            ErrorView(message: "Something went wrong. Please try again.")
                .preferredColorScheme(.dark)
        }
    }
}
