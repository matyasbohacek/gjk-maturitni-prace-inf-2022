//
//  DiseaseDetailModal.swift
//  PlantDiseaseIdentifier
//
//  Created by Matyáš Boháček on 06.01.2023.
//

//
// REFERENCES — Documentation, Code Reference, Forums
//
// TODO: !
//
// REFERENCES — Libraries
//
// TODO: !
//

import SwiftUI

struct DiseaseDetailModal: View {
    @Environment(\.dismiss) var dismiss
    var presentedPlantDisease: PlantDisease
    
    var body: some View {
        
        ScrollView {
            ZStack(alignment: .topTrailing) {
                VStack {
                    Image(presentedPlantDisease.plantDiseasePhotoName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding(.top, 0)
                        .frame(height: 250)
                        .clipped()
                        .mask(LinearGradient(gradient: Gradient(colors: [.clear, Color.white, Color.white]), startPoint: .bottom, endPoint: .top))
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(presentedPlantDisease.plantIconName)
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
                        
                        Spacer()
                            .frame(height: 25)
                        
                        Group {
                            if presentedPlantDisease.isHealthy {
                                HStack {
                                    Image("checkmark-1024")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text("healthy")
                                }
                            } else {
                                HStack {
                                    Image("doctors-bag-1024")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text("disease detected")
                                }
                            }
                        }
                        Group {
                            if !presentedPlantDisease.isHealthy {
                                
                                Group {
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
                                    
                                }
                                
                            } else {
                                Spacer()
                                    .frame(height: 25)
                                Text("While your plant looks healthy now, make sure to check back regularly. Remember that plant diseases are spread easily — the earlier you detect and address an outbreak in your garden, the lesser the overall damage.")
                            }
                            
                            //
                            Group {
                                
                                Spacer()
                                    .frame(height: 25)
                                
                                ForEach(presentedPlantDisease.expertInsights, id: \.0) { item in
                                    constructLinkButton(url: item.0, sourceName: item.1)
                                }

                            
                            }
                            //
                        }
                        
                    }.padding(.leading, 20).padding(.trailing, 20)
                    
                    Spacer()
                }
                closeButton
            }
        }
        
        
    }
    
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

struct DiseaseDetailModal_Previews: PreviewProvider {
    static var previews: some View {
        DiseaseDetailModal(presentedPlantDisease: PlantDisease(mlOutputClassName: "Apple___Apple_scab", name: "Apple — Apple scab", isHealthy: false, symptoms: "", spread: "", prevention: "", plantIconName: "apple-1024", plantDiseasePhotoName: "photo-apple--apple-scab", expertInsights: ["https://www.seznam.cz"]))
    }
}
