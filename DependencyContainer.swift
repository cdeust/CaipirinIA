//
//  DependencyContainer.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//


import Foundation

class DependencyContainer {
    private var factories = [String: Any]()
    
    init() {
        registerDependencies()
    }
    
    private func registerDependencies() {
        register(AppState.self) { AppState() }
        register(CameraServiceProtocol.self) { CameraService(cameraManager: CameraManager()) }
        register(CocktailServiceProtocol.self) {
            CocktailService(networkManager: self.resolve(NetworkManagerProtocol.self))
        }
        register(NetworkManagerProtocol.self) { NetworkManager() }
    }
    
    func register<T>(_ protocolType: T.Type, factory: @escaping () -> T) {
        let key = String(describing: protocolType)
        factories[key] = factory
    }
    
    func resolve<T>(_ protocolType: T.Type) -> T {
        let key = String(describing: protocolType)
        guard let factory = factories[key] as? () -> T else {
            fatalError("No registered factory for \(key)")
        }
        return factory()
    }
}
