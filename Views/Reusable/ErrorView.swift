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
            .foregroundColor(.red)
            .padding()
            .multilineTextAlignment(.center)
    }
}
