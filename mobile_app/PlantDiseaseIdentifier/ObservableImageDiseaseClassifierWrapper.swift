//
//  ObservableImageDiseaseClassifierWrapper.swift
//  PlantDiseaseIdentifier
//
//  Created by Matyáš Boháček on 20.11.2022.
//

import SwiftUI
import Foundation

class ObservableImageDiseaseClassifierWrapper: ObservableObject {
    
    @Published private var classifier = PlantDiseaseClassificationManager()
    
    var imageClass: String? {
        classifier.outputs
    }
        
    func classify(image: UIImage) {
        guard let ciImage = CIImage (image: image) else {
            return
        }
        guard ((try? classifier.classifyDiseases(image: ciImage)) != nil) else {
            return
        }
    }
        
}
