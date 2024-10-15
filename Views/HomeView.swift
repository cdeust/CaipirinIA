//
//  HomeView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color("BackgroundStart"), Color("BackgroundEnd")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Welcome to")
                            .font(.headline)
                            .foregroundColor(Color("PrimaryText"))
                        
                        Text("CaipirinIA")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("SecondaryText"))
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)

                    // Content
                    if appState.preparations.isEmpty {
                        EmptyStateView()
                            .padding(.top, 60)
                            .transition(.opacity)
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(appState.preparations) { preparation in
                                    PreparationCardView(preparation: preparation)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)
                        }
                        .transition(.opacity)
                    }

                    Spacer()

                    // Custom Tab Bar
                    FakeTabBar()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePreparation = Preparation(
            id: UUID(),
            cocktailName: "Margarita",
            datePrepared: Date(),
            steps: [
                "Rub the rim of the glass with the lime slice to make the salt stick to it.",
                "Shake the other ingredients with ice.",
                "Carefully pour into the glass."
            ]
        )
        
        let appState = AppState()
        appState.preparations = [samplePreparation]
        
        return HomeView()
            .environmentObject(appState)
            .previewLayout(.sizeThatFits)
    }
}
