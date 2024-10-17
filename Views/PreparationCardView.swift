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
        VStack(alignment: .leading, spacing: 10) {
            // Top Row: Image, Texts, and Trash Button
            HStack(alignment: .center, spacing: 15) {
                // Cocktail Image
                CocktailImageView(
                    url: preparation.imageName?.absoluteString,
                    width: 50,
                    height: 50,
                    accessibilityLabel: "\(preparation.cocktailName) Image"
                )
                .applyShape(.circle)
                
                // Cocktail Name and Preparation Time
                VStack(alignment: .leading, spacing: 5) {
                    Text(preparation.cocktailName)
                        .font(.headline)
                        .foregroundColor(Color("PrimaryText"))
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text("Prepared on \(formattedDate(preparation.datePrepared))")
                        .font(.subheadline)
                        .foregroundColor(Color("PrimaryText"))
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
            
            DisclosureGroup("View Steps") {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(preparation.steps, id: \.self) { step in
                        HStack(alignment: .top, spacing: 5) {
                            Text("•")
                                .font(.body)
                                .foregroundColor(Color("PrimaryText"))
                            Text(step)
                                .font(.body)
                                .foregroundColor(Color("PrimaryText"))
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.leading, 5) // Slight padding to align with the bullet
                    }
                }
                .padding(.top, 5) // Optional: Adds space between the DisclosureGroup title and the steps
            }
            .accentColor(Color("PrimaryText"))
        }
        .padding()
        .background(Color("BackgroundStart"))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    // Helper function to format date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
