//
//  DatabaseLoadingManager.swift
//  PlantDiseaseIdentifier
//
//  Created by Matyáš Boháček on 05.01.2023.
//

import Foundation
import SwiftCSV

class DatabaseLoadingManager: ObservableObject {
    
    @Published var data: [String: PlantDisease] = [String: PlantDisease]()
    @Published var isReady: Bool = false

    
    init (fileURLPath: String) {
        data = loadDatabase(fileURL: URL(fileURLWithPath: fileURLPath))
    }
    
    init (fileURL: URL) {
        data = loadDatabase(fileURL: fileURL)
    }
    
    public func loadDatabase(fileURL: URL) -> [String: PlantDisease] {
        var databaseClassNameToPlantDisease = [String: PlantDisease]()
        
        do {
            let csvFile = try self.loadDatabaseCSV(fileURL: fileURL)
            try csvFile.enumerateAsDict { dict in
                databaseClassNameToPlantDisease[dict["mlOutputClassName"] ?? ""] = PlantDisease(mlOutputClassName: dict["mlOutputClassName"] ?? "", name: dict["name"] ?? "", isHealthy: ((dict["isHealthy"] ?? "") as NSString).boolValue, symptoms: dict["symptoms"] ?? "", spread: dict["spread"] ?? "", prevention: dict["prevention"] ?? "", plantIconName: dict["plantIconName"] ?? "", plantDiseasePhotoName: dict["plantDiseasePhotoName"] ?? "", expertInsights: (dict["plantExpertInsightURLs"] ?? "" as String).components(separatedBy: ","))
            }
        } catch {
            
        }
        
        return databaseClassNameToPlantDisease
    }
    
    private func loadDatabaseCSV(fileURL: URL) throws -> CSV<Named> {
        let csvFile: CSV = try CSV<Named>(url: fileURL)
        return csvFile
    }
    
}
