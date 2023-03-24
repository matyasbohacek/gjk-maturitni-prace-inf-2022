//
//  PlantDisease.swift
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
//    (None)
//

import Foundation
import UIKit

class PlantDisease {
    
    /// Name of the plant disease in English in the format "[Crop name] — [Disease name / Healthy]"
    let name: String
    
    /// Name of the corresponding class in the classification ML model
    let mlOutputClassName: String
    
    /// Flag for healthy classes
    let isHealthy: Bool
    
    /// Instructions on how to identify the diagnosis (represented as `String` rather than `[String]` or `[enum]` since these are encyclopedic descriptions)
    let symptoms: String
    
    /// Description about how the diagnosed disease spreads (represented as `String` rather than `[String]` or `[enum]` since these are encyclopedic descriptions)
    let spread: String
    
    /// Instructions on how to prevent the diagnosed disease from re-occurring (represented as `String` rather than `[String]` or `[enum]` since these are encyclopedic descriptions)
    let prevention: String
    
    /// Image with an icon of the plan
    let plantIcon: UIImage
    
    /// Image with the photo, showing an example of a plant with the diagnosed disease
    let plantDiseasePhoto: UIImage
    
    /// Links to records in expert databases, structured as tuples with URLs and titles of the originating databases
    let expertInsights: [(URL, String)]
    
    /**
     Adds human-readable titles to known biology- and agriculture-focused internet portals, based on their domains.
     
     - Parameter expertInsights: `[String]` holding `URL`s to the external resources
     
     - Returns: `[(URL, String)]` where each item contains a `URL` and a `String`, with the link and its domain title, respectively
    */
    private static func preprocessLinksWithKnownPortals(expertInsights: [String]) -> [(URL, String)] {
        var expertInsightsPreprocessed = [(URL, String)]()
        
        for insightURLProposal in expertInsights {
            if let insightURLProposalConstructed = URL(string: insightURLProposal) {
                var linkDescription = "Detail"
                
                if insightURLProposal.contains("almanac.com") {
                    linkDescription += " — The Old Farmer's Almanach"
                } else if insightURLProposal.contains("rhs.org.uk") {
                    linkDescription += " — Royal Horticultural Society"
                } else if insightURLProposal.contains("plantvillage.psu.edu") {
                    linkDescription += " — PlantVillage"
                } else if insightURLProposal.contains("cisr.ucr.edu") {
                    linkDescription += " — UCR Invasive Species Research"
                } else if insightURLProposal.contains("ncsu.edu") {
                    linkDescription += " — NC State Extension"
                } else if insightURLProposal.contains("www.canr.msu.edu") {
                    linkDescription += " — MSUE Integrated Pest Management"
                } else if insightURLProposal.contains("www.vegetables.bayer.com") {
                    linkDescription += " — Bayer Vegetables Solutions"
                }
                
                expertInsightsPreprocessed.append((insightURLProposalConstructed, linkDescription))
            }
        }
        
        return expertInsightsPreprocessed
    }

    init(mlOutputClassName: String, name: String, isHealthy: Bool, symptoms: String, spread: String, prevention: String, plantIcon: UIImage, plantDiseasePhoto: UIImage, expertInsights: [String]) {
        self.mlOutputClassName = mlOutputClassName
        self.name = name
        self.isHealthy = isHealthy
        self.symptoms = symptoms
        self.spread = spread
        self.prevention = prevention
        self.plantIcon = plantIcon
        self.plantDiseasePhoto = plantDiseasePhoto
        self.expertInsights = PlantDisease.preprocessLinksWithKnownPortals(expertInsights: expertInsights)
    }
    
}
