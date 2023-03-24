//
//  PlantDiseaseClassificationManagerTests.swift
//  PlantDiseaseIdentifierTests
//
//  Created by Matyáš Boháček on 21.03.2023.
//

import Foundation
import XCTest
import CoreImage
import CoreML
import Vision


class PlantDiseaseClassificationManagerTests: XCTestCase {
    
    var plantDiseaseClassificationManager: PlantDiseaseClassificationManager!
    let testInputImage = CIImage(image: UIImage(named: "apple--black-rot", in: Bundle(for: PlantDiseaseClassificationManagerTests.self), compatibleWith: nil)!)!

    override func setUp() {
        super.setUp()
        plantDiseaseClassificationManager = PlantDiseaseClassificationManager()
    }

    /**
     Tests the `PlantDiseaseClassificationManager.cropLargestPossibleRectangle()` method by supplementing a representative input image and verifying that it is, in fact, reshaped into a rectangle.
     */
    func testPreprocessingCropLargestPossibleRectangle() {
        let croppedInputImage = plantDiseaseClassificationManager.cropLargestPossibleRectangle(input: testInputImage)
        XCTAssertEqual(croppedInputImage.extent.size.width, croppedInputImage.extent.size.height)
    }

    /**
     Tests the `PlantDiseaseClassificationManager.scaleImage()` method by supplementing a representative input image and verifying that its size matches the expected input size of the ML pipeline.
     */
    func testPreprocessingScaleImage() {
        let scaledInputImage = plantDiseaseClassificationManager.scaleImage(input: testInputImage)
        XCTAssertEqual(scaledInputImage.extent.size.width, CGFloat(plantDiseaseClassificationManager.inputSize))
        XCTAssertEqual(scaledInputImage.extent.size.height, CGFloat(plantDiseaseClassificationManager.inputSize))
    }

    /**
     Tests the ML classification pipeline (`PlantDiseaseClassificationManager`) by ensuring that the converted model yields identical predictions as it did on the training instance (i.e., in the Python environment).
     */
    func testDiseaseClassification() {
        // These image-class combinations have been obtained on the training instance first
        let expectedResuls = [("apple--black-rot", "Apple___Black_rot"), ("apple--healthy", "Apple___healthy"), ("corn--northern-leaf-blight", "Corn_(maize)___Northern_Leaf_Blight"), ("potato--early-blight", "Potato___Early_blight")]
        
        for (inputImage, expectedOutputClass) in expectedResuls {
            do {
                try plantDiseaseClassificationManager.classifyDisease(image: CIImage(image: UIImage(named: inputImage, in: Bundle(for: PlantDiseaseClassificationManagerTests.self), compatibleWith: nil)!)!)
                XCTAssertNotNil(plantDiseaseClassificationManager.outputs)
                XCTAssertEqual(plantDiseaseClassificationManager.outputs, expectedOutputClass)
            } catch {
                XCTFail("Error thrown: \(error)")
            }
        }
    }

}
