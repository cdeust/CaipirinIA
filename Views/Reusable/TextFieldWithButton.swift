//
//  TextFieldWithButton.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import SwiftUI

struct TextFieldWithButton: View {
    @EnvironmentObject var appState: AppState
    @Binding var text: String
    var title: String
    var placeholder: String
    var buttonText: String
    var onButtonTap: () -> Void

    var body: some View {
        Section(header: Text(title)) {
            HStack {
                TextField(placeholder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.words)
                
                Button(action: onButtonTap) {
                    Text(buttonText)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(text.isEmpty)
            }
        }
    }
}
