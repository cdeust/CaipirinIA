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

    @Published var detectedItems: [DetectedItem] = []
    @Published var detectedIngredients: [DetectedItem] = [] // Store ingredient and count
    @Published var showCocktailGrid: Bool = false // Navigation trigger
    @Published var detectionCount: Int = 0 // Track number of detections
    @Published var isThresholdReached: Bool = false // Indicates if detection threshold is met
    @Published var detectionProgress: Double = 0.0 // Value between 0 and 1

    private var cancellables = Set<AnyCancellable>()
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
        self.detectedItems = items
        updateDetectedIngredients(from: items)
        updateDetectionProgress(from: items)
        checkThreshold()
    }

    private func updateDetectedIngredients(from items: [DetectedItem]) {
        for item in items {
            if let existingIngredientIndex = detectedIngredients.firstIndex(where: { $0.name == item.name }) {
                detectedIngredients[existingIngredientIndex].count += 1
            } else {
                detectedIngredients.append(DetectedItem(name: item.name, confidence: item.confidence, boundingBox: item.boundingBox, count: 1))
            }
        }
    }

    private func updateDetectionProgress(from items: [DetectedItem]) {
        self.detectionCount += items.count
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
        // Don't reset detection state here to keep ingredients persistent
    }

    func stopCamera() {
        cameraService.stopSession()
        // Only reset detection state when stopping the camera and navigating back
    }

    func resetDetectionState() {
        self.detectedItems = []
        self.detectedIngredients = [] // Reset ingredients only on back
        self.detectionCount = 0
        self.isThresholdReached = false
        self.detectionProgress = 0.0
    }

    func processDetection() {
        self.showCocktailGrid = true
    }
}
