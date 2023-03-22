//
//  ObservableImageDiseaseClassifierWrapper.swift
//  PlantDiseaseIdentifier
//
//  Created by Matyáš Boháček on 20.11.2022.
//
//
//  REFERENCES — Documentation, Code Reference, Forums
//
//    (None)
//
//  REFERENCES — Libraries
//
//    (None)
//

import SwiftUI
import Foundation

class ObservableImageDiseaseClassifierWrapper: ObservableObject {
    
    @Published private var classifier = PlantDiseaseClassificationManager()
    
    var imageClass: String? {
        classifier.outputs
    }
        
    /**
     Classifies the given UIImage using the ML model for plant disease recognition and saves the predicted class (diagnosis).
     
     - Parameter image: UIImage to be classified
     
     - Returns: Does not return — the name of the predicted class is saved as String, available through `.imageClass`
    */
    func classify(image: UIImage) {
        guard let ciImage = CIImage (image: image) else {
            return
        }
        guard ((try? classifier.classifyDisease(image: ciImage)) != nil) else {
            return
        }
    }
        
}
