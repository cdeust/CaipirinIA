//
//  CameraViewModel.swift
//  CaipirinIA
//
//  Created by Clément Deust on 14/10/2024.
//

import SwiftUI
import Combine
import AVFoundation

class CameraViewModel: ObservableObject {
    // Dependencies
    let cameraService: CameraServiceProtocol
    
    // Published Properties
    @Published var detectedItems: [DetectedItem] = []
    @Published var detectedIngredients: [String] = []
    @Published var showCocktailGrid: Bool = false // Navigation trigger
    @Published var detectionCount: Int = 0 // Track number of detections
    @Published var isThresholdReached: Bool = false // Indicates if detection threshold is met
    @Published var detectionProgress: Double = 0.0 // Value between 0 and 1
    
    private var cancellables = Set<AnyCancellable>()
    
    // Threshold for detections
    let detectionThreshold = 40 // Adjust as needed
    
    init(cameraService: CameraServiceProtocol = CameraService(cameraManager: CameraManager())) {
        self.cameraService = cameraService
        setupBindings()
    }
    
    private func setupBindings() {
        cameraService.detectedItemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.handleDetectedItems(items)
            }
            .store(in: &cancellables)
    }
    
    private func handleDetectedItems(_ items: [DetectedItem]) {
        // Update detected items
        self.detectedItems = items
        
        // Update detected ingredients
        updateDetectedIngredients(from: items)
        
        // Update detection count and progress
        updateDetectionProgress(from: items)
        
        // Check if threshold is reached
        checkThreshold()
    }
    
    private func updateDetectedIngredients(from items: [DetectedItem]) {
        // Extract unique ingredient names
        let ingredients = Set(items.map { $0.name })
        self.detectedIngredients = Array(ingredients)
    }
    
    private func updateDetectionProgress(from items: [DetectedItem]) {
        // Increment detection count based on new detections
        self.detectionCount += items.count
        
        // Update progress
        let progress = Double(self.detectionCount) / Double(detectionThreshold)
        self.detectionProgress = min(progress, 1.0)
    }
    
    private func checkThreshold() {
        if self.detectionCount >= detectionThreshold && !self.isThresholdReached {
            self.isThresholdReached = true
            self.detectionProgress = 1.0
            self.showCocktailGrid = false
        }
    }
    
    func startCamera() {
        cameraService.startSession()
        resetDetectionState()
    }
    
    func stopCamera() {
        cameraService.stopSession()
        resetDetectionState()
    }
    
    func processDetection() {
        // Trigger navigation to CocktailGridView
        self.showCocktailGrid = true
    }
    
    func resetDetectionState() {
        self.detectedItems = []
        self.detectedIngredients = []
        self.detectionCount = 0
        self.isThresholdReached = false
        self.detectionProgress = 0.0
    }
}
