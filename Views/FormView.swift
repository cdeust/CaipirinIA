//
//  FormView.swift
//  GroceriesAI
//
//  Created by Clément Deust on 09/07/2024.
//

import SwiftUI

struct FormView: View {
    @EnvironmentObject var appState: AppState
    @State private var favoriteFood: String = ""

    let diets = ["Omnivore", "Vegetarian", "Vegan", "Meat Lover", "Vegetable Lover"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Diet")) {
                    Picker("Diet", selection: $appState.diet) {
                        ForEach(diets, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section(header: Text("Add Favorite Food")) {
                    HStack {
                        TextField("Enter favorite food", text: $favoriteFood)
                        Button(action: {
                            if !favoriteFood.isEmpty {
                                appState.favoriteFoods.append(favoriteFood)
                                favoriteFood = ""
                            }
                        }) {
                            Text("Add")
                        }
                    }
                }

                Section(header: Text("Favorite Foods")) {
                    List(appState.favoriteFoods, id: \.self) { food in
                        Text(food)
                    }
                }

                NavigationLink(destination: CameraView()) {
                    Text("Next")
                }
            }
            .navigationTitle("User Preferences")
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView().environmentObject(AppState())
    }
}
