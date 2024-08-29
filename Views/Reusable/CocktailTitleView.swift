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
            .font(.title)
            .fontWeight(.bold)
            .padding(.bottom, 8)
    }
}
