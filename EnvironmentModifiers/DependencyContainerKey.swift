//
//  DependencyContainerKey.swift
//  CaipirinIA
//
//  Created by Clément Deust on 16/10/2024.
//

import SwiftUI

struct DependencyContainerKey: EnvironmentKey {
    static var defaultValue: DependencyContainer = {
        let container = DependencyContainer()
        return container
    }()
}

extension EnvironmentValues {
    var container: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}
