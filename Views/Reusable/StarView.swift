//
//  StarView.swift
//  CaipirinIA
//
//  Created by Clément Deust on 31/08/2024.
//

import SwiftUI

struct StarView: View {
    var body: some View {
        Image(systemName: "star.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.yellow)
            .shadow(color: .yellow, radius: 5, x: 0, y: 0)
    }
}

#Preview {
    StarView()
}
