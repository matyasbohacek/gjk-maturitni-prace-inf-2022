//
//  DiseaseDetailModal.swift
//  PlantDiseaseIdentifier
//
//  Created by Matyáš Boháček on 06.01.2023.
//
//
//  REFERENCES — Documentation, Code Reference, Forums
//
//    - StackOverflow, available https://stackoverflow.com/questions/63567741/dismiss-button-x-on-an-image-top-right-alignment-how – this resource was later used as reference during debugging
//
//  REFERENCES — Libraries
//
//    (None)
//

import SwiftUI

struct DiseaseDetailModal: View {
    
    // MARK: Properties
    var presentedPlantDisease: PlantDisease
    
    // MARK: State variables
    @Environment(\.dismiss) var dismiss
    
    // MARK: UI Components
    var body: some View {
        ScrollView {
            ZStack(alignment: .topTrailing) {
                VStack {
                    topExampleImageView
                    VStack(alignment: .leading) {
                        plantIdentifierHeaderView
                        Spacer()
                            .frame(height: 25)
                        if presentedPlantDisease.isHealthy {
                            healthyBadgeView
                            healthyDescriptionView
                        } else {
                            diseasedBadgeView
                            diseasedDescriptionView
                        }
                        expertInsightButtonsView
                    }.padding(.leading, 20).padding(.trailing, 20)
                    Spacer()
                }
                closeButton
            }
        }
    }
    
    /// Top view with the fading image, showing an example plant of the respective condition
    var topExampleImageView: some View {
        Image(uiImage: presentedPlantDisease.plantDiseasePhoto)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .padding(.top, 0)
            .frame(height: 250)
            .clipped()
            .mask(LinearGradient(gradient: Gradient(colors: [.clear, Color.white, Color.white]), startPoint: .bottom, endPoint: .top))
    }
    
    /// View containing the title and icon of the plant condition
    var plantIdentifierHeaderView: some View {
        HStack {
            Image(uiImage: presentedPlantDisease.plantIcon)
                .resizable()
                .frame(width: 40, height: 40)
                .padding(10)
                .background(Color.white)
                .cornerRadius(8)
                .padding(2)
                .background(Color.primary)
                .cornerRadius(10)
            Text(presentedPlantDisease.name)
                .frame(height: 80)
                .font(.title)
                .bold()
                .lineLimit(2)
            
            Spacer()
        }.frame(alignment: .leading).padding(.top, -30)
    }
    
    /// View containing a status badge for healthy plants
    var healthyBadgeView: some View {
        HStack {
            Image("checkmark-1024")
                .resizable()
                .frame(width: 20, height: 20)
            Text("healthy")
        }
    }
    
    /// View containing a status badge for diseased plants
    var diseasedBadgeView: some View {
        HStack {
            Image("doctors-bag-1024")
                .resizable()
                .frame(width: 20, height: 20)
            Text("disease detected")
        }
    }
    
    /// View containing the text description — symptoms, spread, and prevention — of diseased plants
    var diseasedDescriptionView: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 25)
            
            Text("Symptoms")
                .font(.title3)
                .bold()
            Text(presentedPlantDisease.symptoms)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
                .frame(height: 25)
            
            Text("Spread")
                .font(.title3)
                .bold()
            Text(presentedPlantDisease.spread)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
                .frame(height: 25)
            
            Text("Prevention")
                .font(.title3)
                .bold()
            Text(presentedPlantDisease.prevention)
                .fixedSize(horizontal: false, vertical: true)
        }.padding(0)
    }
    
    /// View containing a generic text description of healthy plants
    var healthyDescriptionView: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 25)
            Text("While your plant looks healthy now, make sure to check back regularly. Remember that plant diseases are spread easily — the earlier you detect and address an outbreak in your garden, the lesser the overall damage.")
        }.padding(0)
    }
    
    /// Button that closes the modal (i.e., returns to the ContentView)
    var closeButton: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .padding(20)
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 5)
            Spacer()
        }
    }
    
    /// View containing buttons that link to external expert databases with relevant information about this condition
    var expertInsightButtonsView: some View {
        VStack {
            Spacer()
                .frame(height: 25)
            ForEach(presentedPlantDisease.expertInsights, id: \.0) { item in
                constructLinkButton(url: item.0, sourceName: item.1)
            }
        }
    }
    
    // MARK: Methods
    
    /**
     Creates an external internet link from the given title and URL.
     
     - Parameter url: URL that should be linked
     - Parameter sourceName: String with the title of the button
     
     - Returns: Button (within SwiftUI)
     */
    func constructLinkButton(url: URL, sourceName: String) -> some View {
        return Button(action: {
            UIApplication.shared.open(url)
        }) {
            HStack (alignment: .top) {
                Image(systemName: "arrow.up.right")
                    .foregroundColor(.white)
                    .font(.body)
                    .padding(.top, 3)
                Text(sourceName)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(15)
            .background(.green)
        }
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}

// MARK: Preview

struct DiseaseDetailModal_Previews: PreviewProvider {
    static var previews: some View {
        DiseaseDetailModal(presentedPlantDisease: PlantDisease(mlOutputClassName: "Apple___Apple_scab", name: "Apple — Apple scab", isHealthy: false, symptoms: "", spread: "", prevention: "", plantIcon: UIImage(named: "apple-1024")!, plantDiseasePhoto: UIImage(named: "photo-apple--apple-scab")!, expertInsights: ["https://www.seznam.cz"]))
    }
}
