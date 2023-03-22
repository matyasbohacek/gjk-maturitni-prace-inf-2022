//
//  DatabaseLoadingManager.swift
//  PlantDiseaseIdentifier
//
//  Created by Matyáš Boháček on 05.01.2023.
//
//
//  REFERENCES — Documentation, Code Reference, Forums
//
//    (None)
//
//  REFERENCES — Libraries
//
//    - SwiftCSV, available at https://github.com/swiftcsv/SwiftCSV
//

import Foundation
import SwiftCSV
import UIKit


enum DatabaseLoadingError: Error, Equatable {
    static func == (lhs: DatabaseLoadingError, rhs: DatabaseLoadingError) -> Bool {
        return lhs.description == rhs.description
    }
    
    case incorrectFormat
    case linkedImageResourcesNonExistant
    case unknownShallow(error: Error)
}


extension DatabaseLoadingError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .incorrectFormat:
            return "The format of the CSV is incorrect. Please see the documentation to see the expected header."
        case .linkedImageResourcesNonExistant:
            return "The linked image resource is not packaged with the app."
        case .unknownShallow(_):
            return "An unexpected error occurred."
        }
    }
}


class ObservableDatabaseLoadingWrapper: ObservableObject {
    
    @Published var data: [String: PlantDisease] = [String: PlantDisease]()
    @Published var isReady: Bool = false

    init (fileURLPath: String) throws {
        data = try loadDatabase(fileURL: URL(fileURLWithPath: fileURLPath))
    }
    
    init (fileURL: URL) throws {
        data = try loadDatabase(fileURL: fileURL)
    }
    
    init () {
        
    }
    
    /**
     Reads plant disease data from a designated CSV file. Note that the CSV must be structured in the following header format:
        
        mlOutputClassName;name;isHealthy;symptoms;spread;prevention;plantIconName;plantDiseasePhotoName;plantExpertInsightURLs
     
     Moreover, the items must be separated by a semicolon (;).
     
     - Parameter fileURL: URL of the CSV file to read
     
     - Returns: Dictionary, in which keys correspond to ML model's output class names, and values to respective PlantDisease objects
    */
    public func loadDatabase(fileURL: URL) throws -> [String: PlantDisease] {
        var databaseClassNameToPlantDisease = [String: PlantDisease]()
        
        let csvFile = try self.loadDatabaseCSV(fileURL: fileURL)
            
        // TODO
        for expectedColumn in ["mlOutputClassName", "name", "isHealthy", "symptoms", "spread", "prevention", "plantIconName", "plantDiseasePhotoName", "plantExpertInsightURLs"] {
            if !csvFile.header.contains(expectedColumn) {
                throw DatabaseLoadingError.incorrectFormat
            }
        }

        do {
            
            var imageResourcesNotLinked = false
            try csvFile.enumerateAsDict { dict in
                
                let plantDiseasePhoto = UIImage(named: dict["plantDiseasePhotoName"] ?? "")
                let plantIcon = UIImage(named: dict["plantIconName"] ?? "")
                
                if plantDiseasePhoto == nil || plantIcon == nil {
                    imageResourcesNotLinked = true
                } else { databaseClassNameToPlantDisease[dict["mlOutputClassName"]!] = PlantDisease(mlOutputClassName: dict["mlOutputClassName"]!, name: dict["name"]!, isHealthy: ((dict["isHealthy"]!) as NSString).boolValue, symptoms: dict["symptoms"]!, spread: dict["spread"]!, prevention: dict["prevention"]!, plantIcon: plantIcon!, plantDiseasePhoto: plantDiseasePhoto!, expertInsights: (dict["plantExpertInsightURLs"])!.components(separatedBy: ","))
                }
            }
            
            if imageResourcesNotLinked {
                throw DatabaseLoadingError.linkedImageResourcesNonExistant
            }
        } catch DatabaseLoadingError.linkedImageResourcesNonExistant {
            throw DatabaseLoadingError.linkedImageResourcesNonExistant
        } catch {
            throw DatabaseLoadingError.unknownShallow(error: error)
        }
       
        return databaseClassNameToPlantDisease
    }
    
    private func loadDatabaseCSV(fileURL: URL) throws -> CSV<Named> {
        let csvFile: CSV = try CSV<Named>(url: fileURL)
        return csvFile
    }
    
}
