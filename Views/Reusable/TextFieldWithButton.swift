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
        Section(header: Text(title).font(.headline).padding(.bottom, 4)) {
            HStack {
                TextField(placeholder, text: $text)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.7), lineWidth: 1)
                    )
                    .shadow(color: Color.primary.opacity(0.1), radius: 2, x: 0, y: 1)
                    .padding(.trailing, 8)
                
                Button(action: onButtonTap) {
                    Text(buttonText)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.orange, Color.red]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: Color.primary.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                .disabled(text.isEmpty)
                .opacity(text.isEmpty ? 0.6 : 1.0)
            }
            .padding(.horizontal)
        }
    }
}

struct TextFieldWithButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TextFieldWithButton(
                text: .constant("Sample Text"),
                title: "Enter Cocktail Name",
                placeholder: "Type something...",
                buttonText: "Add",
                onButtonTap: {}
            )
            .environmentObject(AppState())
            .preferredColorScheme(.light)

            TextFieldWithButton(
                text: .constant("Sample Text"),
                title: "Enter Cocktail Name",
                placeholder: "Type something...",
                buttonText: "Add",
                onButtonTap: {}
            )
            .environmentObject(AppState())
            .preferredColorScheme(.dark)
        }
    }
}
