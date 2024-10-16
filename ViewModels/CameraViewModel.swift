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
    let cameraService: CameraServiceProtocol

    @Published var detectedItems: [DetectedItem] = [] // All detected items
    @Published var detectedIngredients: [DetectedItem] = [] // All ingredients (validated and unvalidated)
    @Published var validatedIngredients: [DetectedItem] = [] // Only validated ingredients (count > 40)
    @Published var showCocktailGrid: Bool = false // Navigation trigger
    @Published var detectionCount: Int = 0 // Total number of validated detections after validation
    @Published var isThresholdReached: Bool = false // Indicates if detection threshold is met
    @Published var detectionProgress: Double = 0.0 // Value between 0 and 1, based on validated detections

    private var cancellables = Set<AnyCancellable>()
    let detectionThreshold = 40 // Threshold for unlocking the button

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

    // Handle detected items
    private func handleDetectedItems(_ items: [DetectedItem]) {
        self.detectedItems = items
        updateDetectedIngredients(from: items)
        updateValidationProgress(from: self.validatedIngredients) // Update progress based on validated items
        checkThreshold()
    }

    // Update both detected ingredients and validated ingredients
    private func updateDetectedIngredients(from items: [DetectedItem]) {
        for item in items {
            if let existingIngredientIndex = detectedIngredients.firstIndex(where: { $0.name == item.name }) {
                // Increment detection count for existing items
                detectedIngredients[existingIngredientIndex].count += 1
            } else {
                // New detected item
                detectedIngredients.append(DetectedItem(name: item.name, confidence: item.confidence, boundingBox: item.boundingBox, count: 1))
            }
        }
        
        // Now filter out the validated ingredients (count > 40)
        withAnimation {
            validatedIngredients = detectedIngredients.filter { $0.count > 40 }
        }
    }

    // Update the detection progress for validated items
    private func updateValidationProgress(from validatedItems: [DetectedItem]) {
        // Count only the additional detections of validated ingredients
        let additionalDetections = validatedItems.reduce(0) { $0 + $1.count - 40 } // Only counts > 40 contribute to progress
        self.detectionCount = additionalDetections

        // Update the progress
        let progress = Double(self.detectionCount) / Double(detectionThreshold)
        self.detectionProgress = min(progress, 1.0)
    }

    // Check if the threshold is met
    private func checkThreshold() {
        if self.detectionCount >= detectionThreshold && !self.isThresholdReached {
            self.isThresholdReached = true
            self.detectionProgress = 1.0
            self.showCocktailGrid = false
        }
    }

    func startCamera() {
        cameraService.startSession()
        // Don't reset detection state here to keep ingredients persistent
    }

    func stopCamera() {
        cameraService.stopSession()
        // Only reset detection state when stopping the camera and navigating back
    }

    func resetDetectionState() {
        self.detectedItems = []
        self.detectedIngredients = [] // Reset both detected and validated ingredients
        self.validatedIngredients = []
        self.detectionCount = 0
        self.isThresholdReached = false
        self.detectionProgress = 0.0
    }

    func processDetection() {
        self.showCocktailGrid = true
    }
}
