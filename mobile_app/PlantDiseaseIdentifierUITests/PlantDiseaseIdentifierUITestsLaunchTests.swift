//
//  PlantDiseaseIdentifierUITestsLaunchTests.swift
//  PlantDiseaseIdentifierUITests
//
//  Created by Matyáš Boháček on 20.11.2022.
//

import XCTest

class PlantDiseaseIdentifierUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
}
