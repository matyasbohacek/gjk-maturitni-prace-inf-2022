//
//  PlantDiseaseClassificationManager.swift
//  PlantDiseaseIdentifier
//
//  Created by Matyáš Boháček on 20.11.2022.
//

import CoreML
import CoreImage
import Vision
import Foundation

enum PlantDiseaseMLModelError: Error {
    case modelNotLoadedProperly
    case modelRepresentationMismatch
}

struct PlantDiseaseClassificationManager {
    
    public var outputs: String?
    let inputSize = 150.0
    
    /**
     TODO
     
     - Parameter image:
     
     - Returns:
    */
    private func cropLargestPossibleRectangle(input: CIImage) -> CIImage {
        
        if input.extent.size.width == input.extent.size.height {
            return input
        }
        
        //
        let size: CGFloat
        if input.extent.size.width > input.extent.size.height {
            size = input.extent.size.height
        } else {
            size = input.extent.size.width
        }
        
        let cropZone = CGRect(x: (input.extent.size.width - size) / 2, y: (input.extent.size.height - size) / 2, width: size, height: size)
        
        return input.cropped(to: cropZone)
        
    }
    
    /**
     TODO
     
     - Parameter image:
     
     - Returns:
    */
    private func scaleImage(input: CIImage) -> CIImage {
        
        let scaleX = inputSize / input.extent.size.width
        let scaleY = inputSize / input.extent.size.height
        
        return input.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
    }
    
    
    /**
     Analyzes the provided image using a pre-trained machine learning model for plant disease classification.
     
     - Parameter image: CIImage of the image to infer on the ML model
     
     - Throws: PlantDiseaseMLModelError in case the model does not load properly or if the output does not match expected structure
     - Returns: Does not return – mutating function (per Swift's standard conventions, follow general-purpose language docs)
    */
    mutating func classifyDiseases(image: CIImage) throws {
        
        // Pre-process the image to match the model's expected format
        var preprocessedImage = cropLargestPossibleRectangle(input: image)
        preprocessedImage = scaleImage(input: preprocessedImage)
        
        let config = MLModelConfiguration()
        config.computeUnits = .cpuOnly

        guard let model = try? VNCoreMLModel(for: PlantDiseaseClassifier(configuration: config).model) else {
            throw PlantDiseaseMLModelError.modelNotLoadedProperly
        }
        
        let request = VNCoreMLRequest(model: model)
        let handler = VNImageRequestHandler(ciImage: preprocessedImage, options: [:])
        
        try? handler.perform([request])

        // Ensure that the model outputs expected classification structure type
        guard let output = request.results as? [VNClassificationObservation] else {
            throw PlantDiseaseMLModelError.modelRepresentationMismatch
        }
        
        // Only save the results if present
        if let firstOutput = output.first {
            self.outputs = firstOutput.identifier
        }
        
    }
    
}
