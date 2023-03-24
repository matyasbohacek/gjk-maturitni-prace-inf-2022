//
//  PlantDiseaseClassificationManager.swift
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
    
    /// Size of the image, as expected at input to the ML model
    let inputSize = 150.0
    
    /**
     Fits the largest possible rectangle to the center of the given image and crops it.
     
     - Parameter input: `CIImage` of any proportion to be cropped
     
     - Returns: Cropped rectangular `CIImage`
    */
    func cropLargestPossibleRectangle(input: CIImage) -> CIImage {
        // Avoid unnecessary computation if the objective is already satisfied (i.e., the image is already a rectangle)
        if input.extent.size.width == input.extent.size.height {
            return input
        }
        
        // Fit the largest rectangle
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
     Scales the given image to the size expected at the input to the ML model.
     
     - Parameter input: `CIImage` of any size to be scaled
     
     - Returns: Scaled `CIImage`
    */
    func scaleImage(input: CIImage) -> CIImage {
        let scaleX = inputSize / input.extent.size.width
        let scaleY = inputSize / input.extent.size.height
        
        return input.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
    }
    
    /**
     Analyzes the provided image using a pre-trained machine learning model for plant disease classification.
     
     - Parameter image: `CIImage` to be analyzed by the ML model
     
     - Throws: `PlantDiseaseMLModelError` in case the model does not load properly or if the output does not match expected structure
     - Returns: Does not return – mutating function (per Swift's standard convention, to allow for async UI observability, follow general-purpose language docs)
    */
    mutating func classifyDisease(image: CIImage) throws {
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
        
        if let firstOutput = output.first {
            self.outputs = firstOutput.identifier
        }
    }
    
}
