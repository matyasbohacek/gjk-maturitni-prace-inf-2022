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
    let sampleImage = CIImage(image: UIImage(named: "apple--black-rot", in: Bundle(for: PlantDiseaseClassificationManagerTests.self), compatibleWith: nil)!)!

    override func setUp() {
        super.setUp()
        plantDiseaseClassificationManager = PlantDiseaseClassificationManager()
    }

    func testCropLargestPossibleRectangle() {
        // TODO
        let croppedImage = plantDiseaseClassificationManager.cropLargestPossibleRectangle(input: sampleImage)
        XCTAssertEqual(croppedImage.extent.size.width, croppedImage.extent.size.height)
    }

    func testScaleImage() {
        // TODO
        let scaledImage = plantDiseaseClassificationManager.scaleImage(input: sampleImage)
        XCTAssertEqual(scaledImage.extent.size.width, CGFloat(plantDiseaseClassificationManager.inputSize))
        XCTAssertEqual(scaledImage.extent.size.height, CGFloat(plantDiseaseClassificationManager.inputSize))
    }

    func testClassifyDisease() {
        // TODO
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
