//
//  HomeView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI

struct HomeView: View {
    let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }

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
                    if container.resolve(AppState.self).preparations.isEmpty {
                        EmptyStateView()
                            .padding(.top, 60)
                            .transition(.opacity)
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(container.resolve(AppState.self).preparations) { preparation in
                                    PreparationCardView(preparation: preparation)
                                        .environmentObject(container.resolve(AppState.self))
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)
                        }
                        .transition(.opacity)
                    }

                    Spacer()

                    // Custom Tab Bar
                    FakeTabBar(container: container)
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
        
        let container = DependencyContainer()
        container.resolve(AppState.self).preparations = [samplePreparation]
        
        return HomeView(container: container)
            .environmentObject(container.resolve(AppState.self))
            .previewLayout(.sizeThatFits)
    }
}
