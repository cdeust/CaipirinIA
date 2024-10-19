//
//  PreparationStepsView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 15/10/2024.
//

import SwiftUI

struct PreparationStepsView: View {
    let cocktail: Cocktail
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode

    @State private var currentStepIndex: Int = 0
    @State private var showCompletionAlert: Bool = false

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Step Indicator
                Text("Step \(currentStepIndex + 1) of \(steps.count)")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(Color("PrimaryText"))

                // Step Content
                Text(steps[currentStepIndex])
                    .font(.system(.title2, design: .rounded))
                    .foregroundColor(Color("PrimaryText"))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color("BackgroundStart"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)

                Spacer()

                // "Next Step" or "Preparation Done" Button
                Button(action: {
                    if currentStepIndex < steps.count - 1 {
                        currentStepIndex += 1
                    } else {
                        showCompletionAlert = true
                    }
                }) {
                    Text(currentStepIndex < steps.count - 1 ? "Next Step" : "Preparation Done")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .alert(isPresented: $showCompletionAlert) {
            Alert(
                title: Text("Congratulations!"),
                message: Text("You've completed preparing the \(cocktail.strDrink)."),
                primaryButton: .default(Text("OK")) {
                    addPreparation()
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
        .navigationBarTitle("Prepare \(cocktail.strDrink)", displayMode: .inline)
    }

    private var steps: [String] {
        guard let instructions = cocktail.strInstructions else { return [] }
        return instructions.splitIntoSteps()
    }

    private func addPreparation() {
        let preparation = Preparation(
            id: UUID(),
            cocktailId: cocktail.idDrink ?? UUID().uuidString,
            cocktailName: cocktail.strDrink,
            datePrepared: Date(),
            steps: steps,
            imageName: URL(string: cocktail.strDrinkThumb ?? ""),
            strCategory:cocktail.strCategory,
            strAlcoholic: cocktail.strAlcoholic,
            strGlass: cocktail.strGlass,
            strInstructions: cocktail.strInstructions,
            strIngredient1: cocktail.strIngredient1,
            strIngredient2: cocktail.strIngredient2,
            strIngredient3: cocktail.strIngredient3,
            strIngredient4: cocktail.strIngredient4,
            strIngredient5: cocktail.strIngredient5,
            strIngredient6: cocktail.strIngredient6,
            strIngredient7: cocktail.strIngredient7,
            strIngredient8: cocktail.strIngredient8,
            strIngredient9: cocktail.strIngredient9,
            strIngredient10: cocktail.strIngredient10,
            strDrinkThumb: cocktail.strDrinkThumb,
            source: .generated
        )
        appState.addPreparation(preparation)
    }
}
