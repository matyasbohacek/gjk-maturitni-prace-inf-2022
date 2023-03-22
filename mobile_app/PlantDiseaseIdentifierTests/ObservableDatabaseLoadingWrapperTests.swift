//
//  DatabaseLoadingManagerTests.swift
//  PlantDiseaseIdentifier
//
//  Created by Matyáš Boháček on 05.01.2023.
//

import Foundation
import XCTest

class ObservableDatabaseLoadingWrapperTests: XCTestCase {
    
    var databaseWrapper: ObservableDatabaseLoadingWrapper!
    
    override func setUp() {
        super.setUp()
        
        let testBundle = Bundle(for: type(of: self))
        guard let testCSVFilePath = testBundle.path(forResource: "plantvillage-database-test-subsplit", ofType: "csv") else {
            XCTFail("Failed to find test CSV file.")
            return
        }
        
        XCTAssertNoThrow(databaseWrapper = try ObservableDatabaseLoadingWrapper(fileURLPath: testCSVFilePath))
    }

    override func tearDown() {
        databaseWrapper = nil
        super.tearDown()
    }

    func testDatabaseLoading() {
        // For the purpose of this test case, a testing subsplit of the dataset was created
        let testFileURL = Bundle(for: type(of: self)).url(forResource: "plantvillage-database-test-subsplit", withExtension: "csv")!

        let expectedNames = ["Apple — Apple scab", "Apple — Black rot", "Apple — Cedar apple rust", "Apple — healthy"]
        let expectedMLOutputClassName = ["Apple___Apple_scab", "Apple___Black_rot", "Apple___Cedar_apple_rust", "Apple___healthy"]

        var database = [String: PlantDisease]()
        XCTAssertNoThrow(database = try databaseWrapper.loadDatabase(fileURL: testFileURL))
        
        // Ensure that the overall size of the database matches
        XCTAssertEqual(database.count, expectedNames.count)
        
        // Ensure that the data is loaded as expected
        for (outputClassName, plantDisease) in database {
            XCTAssertTrue(expectedMLOutputClassName.contains(outputClassName))
            XCTAssertTrue(expectedNames.contains(plantDisease.name))
        }
    }
    
    func testInvalidDataLoading() {
        // For the purpose of this test case, a testing subsplit of the dataset was created
        let testFileFaultyFormatURL = Bundle(for: type(of: self)).url(forResource: "plantvillage-database-test-subsplit-faulty-format", withExtension: "csv")!
        let testFileFaultyDataURL = Bundle(for: type(of: self)).url(forResource: "plantvillage-database-test-subsplit-faulty-data", withExtension: "csv")!
        
        // TODO: test
        XCTAssertThrowsError(try databaseWrapper.loadDatabase(fileURL: testFileFaultyFormatURL)) { error in
            XCTAssertEqual(error as! DatabaseLoadingError, DatabaseLoadingError.incorrectFormat)
        }
        
        // TODO: test
        XCTAssertThrowsError(try databaseWrapper.loadDatabase(fileURL: testFileFaultyDataURL)) { error in
            XCTAssertEqual(error as! DatabaseLoadingError, DatabaseLoadingError.linkedImageResourcesNonExistant)
        }
        
    }
    
}
