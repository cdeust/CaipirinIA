//
//  KeyboardResponsiveModifier.swift
//  CaipirinIA
//
//  Created by Clément Deust on 31/08/2024.
//

import SwiftUI
import Combine

struct KeyboardResponsiveModifier: ViewModifier {
    @State private var currentHeight: CGFloat = 0
    @State private var cancellables = Set<AnyCancellable>()

    func body(content: Content) -> some View {
        content
            .padding(.bottom, currentHeight)
            .onAppear(perform: subscribeToKeyboardEvents)
    }

    private func subscribeToKeyboardEvents() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification))
            .compactMap { notification in
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .map { rect in
                rect.height
            }
            .sink { height in
                self.currentHeight = height
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
            .sink { height in
                self.currentHeight = height
            }
            .store(in: &cancellables)
    }
}

extension View {
    func keyboardResponsive() -> some View {
        self.modifier(KeyboardResponsiveModifier())
    }
}
