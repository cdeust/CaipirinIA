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
    
    // State to track current step
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
                    .font(.headline)
                    .foregroundColor(Color("PrimaryText"))
                
                // Step Content
                Text(steps[currentStepIndex])
                    .font(.title2)
                    .foregroundColor(Color("PrimaryText"))
                    .multilineTextAlignment(.leading) // Align text to the left
                    .frame(maxWidth: .infinity, alignment: .leading) // Expand to full width
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Enhanced shadow for visibility
                
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
                        .foregroundColor(.white) // White text for better contrast
                        .frame(maxWidth: .infinity) // Button takes full width
                        .padding()
                        .background(Color("BackgroundStart")) // Use a distinct background color
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Enhanced shadow
                }
                .padding(.horizontal) // Consistent horizontal padding
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
    
    // Enhanced Step Splitting Logic
    private var steps: [String] {
        guard let instructions = cocktail.strInstructions else { return [] }
        return instructions.splitIntoSteps()
    }
    
    // Corrected Function to Add Preparation
    private func addPreparation() {
        let preparation = Preparation(
            id: UUID(),
            cocktailId: cocktail.idDrink ?? UUID().uuidString,
            cocktailName: cocktail.strDrink,
            datePrepared: Date(),
            steps: steps,
            imageName: URL(string: cocktail.strDrinkThumb ?? "")
        )
        appState.addPreparation(preparation)
    }
}
