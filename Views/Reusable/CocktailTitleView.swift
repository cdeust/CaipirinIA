//
//  CocktailTitleView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 29/08/2024.
//

import SwiftUI

struct CocktailTitleView: View {
    @EnvironmentObject var appState: AppState
    var title: String

    var body: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.primary)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(
                Color(UIColor.systemBackground)
                    .cornerRadius(12)
                    .shadow(color: Color.primary.opacity(0.1), radius: 4, x: 0, y: 2)
            )
            .padding(.horizontal)
    }
}

struct CocktailTitleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CocktailTitleView(title: "Margarita")
                .environmentObject(AppState())
                .preferredColorScheme(.light)

            CocktailTitleView(title: "Margarita")
                .environmentObject(AppState())
                .preferredColorScheme(.dark)
        }
    }
}
