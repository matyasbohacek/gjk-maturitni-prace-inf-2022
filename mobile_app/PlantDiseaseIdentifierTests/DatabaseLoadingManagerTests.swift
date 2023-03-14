//
//  DatabaseLoadingManagerTests.swift
//  PlantDiseaseIdentifier
//
//  Created by Matyáš Boháček on 05.01.2023.
//

import Foundation
import XCTest

class DatabaseLoadingManagerTests: XCTestCase {
    
    func testLoadDatabase() throws {
        let manager = DatabaseLoadingManager(fileURL: Bundle.main.url(forResource: "plantvillage-database", withExtension: "csv")!)
        
        // Test that the database is initially empty
        // XCTAssertEqual(manager.database.count, 0)
        
        // Load the database
        let csvFile = try manager.loadDatabase()
        XCTAssertNotNil(csvFile)

        
        // Test that the database is not empty after loading
        // XCTAssertNotEqual(manager.database.count, 0)
        
        // Test that all the entries in the database have the correct structure
        /* for entry in manager.database {
            XCTAssertNotNil(entry.id)
            XCTAssertNotNil(entry.name)
            XCTAssertNotNil(entry.description)
            XCTAssertNotNil(entry.price)
        } */
    }
    
}
