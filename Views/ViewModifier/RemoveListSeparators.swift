//
//  RemoveListSeparators.swift
//  CaipirinIA
//
//  Created by Clément Deust on 30/08/2024.
//

import SwiftUI

struct RemoveListSeparators: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                UITableView.appearance().separatorStyle = .none
            }
            .onDisappear {
                UITableView.appearance().separatorStyle = .singleLine
            }
    }
}

extension View {
    func removeListSeparators() -> some View {
        self.modifier(RemoveListSeparators())
    }
}
