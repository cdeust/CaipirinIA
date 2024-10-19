//
//  PreparationCardView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 15/10/2024.
//

import SwiftUI

struct PreparationCardView: View {
    let preparation: Preparation
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top Row: Image, Texts, and Trash Button
            HStack(alignment: .center, spacing: 15) {
                ZStack {
                    Color("BackgroundEnd")
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    // Cocktail Image
                    CocktailImageView(
                        url: preparation.imageName?.absoluteString,
                        width: 50,
                        height: 50,
                        shapeType: .circle,
                        accessibilityLabel: "\(preparation.cocktailName) Image"
                    )
                }
                
                // Cocktail Name and Preparation Time
                VStack(alignment: .leading, spacing: 4) {
                    Text(preparation.cocktailName)
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(Color("PrimaryText"))
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text("Prepared on \(formattedDate(preparation.datePrepared))")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                
                Spacer()
                
                // Trash Button
                Button(action: {
                    appState.deletePreparation(preparation)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .imageScale(.large)
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("Delete Preparation")
            }
            
            // Steps section
            DisclosureGroup("View Steps") {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(preparation.steps, id: \.self) { step in
                        HStack(alignment: .top, spacing: 5) {
                            Text("•")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(Color("PrimaryText"))
                            Text(step)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(Color("PrimaryText"))
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.leading, 5)
                }
                .padding(.top, 5)
            }
            .accentColor(Color("PrimaryText"))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.9))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        )
        .padding(.vertical, 10)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
