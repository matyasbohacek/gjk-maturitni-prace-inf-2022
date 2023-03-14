//
//  PlantDisease.swift
//  PlantDiseaseIdentifier
//
//  Created by Matyáš Boháček on 05.01.2023.
//

import Foundation

class PlantDisease {
    
    let mlOutputClassName: String
    let name: String
    
    let isHealthy: Bool
    let symptoms: String
    let spread: String
    let prevention: String
    
    let plantIconName: String
    let plantDiseasePhotoName: String
    
    let expertInsights: [(URL, String)]

    init(mlOutputClassName: String, name: String, isHealthy: Bool, symptoms: String, spread: String, prevention: String, plantIconName: String, plantDiseasePhotoName: String, expertInsights: [String]) {
        self.mlOutputClassName = mlOutputClassName
        self.name = name
        
        self.isHealthy = isHealthy
        self.symptoms = symptoms
        self.spread = spread
        self.prevention = prevention
        
        self.plantIconName = plantIconName
        self.plantDiseasePhotoName = plantDiseasePhotoName
        
        var expertInsightsPreprocessed = [(URL, String)]()
        
        for insightURLProposal in expertInsights {
            if let insightURLProposalConstructed = URL(string: insightURLProposal) {
                
                // TODO: Pop into a separate method
                var linkDescription = "Expert information"
                if insightURLProposal.contains("almanac.com") {
                    linkDescription = "Detail — The Old Farmer's Almanach"
                } else if insightURLProposal.contains("rhs.org.uk") {
                    linkDescription = "Detail — Royal Horticultural Society"
                } else if insightURLProposal.contains("plantvillage.psu.edu") {
                    linkDescription = "Detail — PlantVillage"
                } else if insightURLProposal.contains("cisr.ucr.edu") {
                    linkDescription = "Detail — UCR Invasive Species Research"
                } else if insightURLProposal.contains("ncsu.edu") {
                    linkDescription = "Detail — NC State Extension"
                } else if insightURLProposal.contains("www.canr.msu.edu") {
                    linkDescription = "Detail — MSUE Integrated Pest Management"
                } else if insightURLProposal.contains("www.vegetables.bayer.com") {
                    linkDescription = "Detail — Bayer Vegetables Solutions"
                }
                
                expertInsightsPreprocessed.append((insightURLProposalConstructed, linkDescription))
            }
        }
        
        self.expertInsights = expertInsightsPreprocessed
    }
    
}
