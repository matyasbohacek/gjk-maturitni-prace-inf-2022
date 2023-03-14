//
//  PlantDiseaseIdentifierApp.swift
//  PlantDiseaseIdentifier
//
//  Created by Matyáš Boháček on 20.11.2022.
//

import SwiftUI
import Photos
import AVKit
import AVFoundation

@main
struct PlantDiseaseIdentifierApp: App {
    
    init() {
        askForCameraAndPhotosPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(classifier: ObservableImageDiseaseClassifierWrapper())
        }
    }
    
    func askForCameraAndPhotosPermission() -> Void {
        if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { _ in
                // Response may be ignored — if the access is not granted, this window will be re-prompted at a relevant time (i.e., when the user tries to open camera roll and snap a plant
            }
        }
        
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization() { _ in
                // Response may be ignored — if the access is not granted, this window will be re-prompted at a relevant time (i.e., when the user tries to select photos
            }
        }
    }
    
}
