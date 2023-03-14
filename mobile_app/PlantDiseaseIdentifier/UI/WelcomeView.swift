//
//  WelcomeView.swift
//  PlantDiseaseIdentifier
//
//  Created by Matyáš Boháček on 17.02.2023.
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

struct WelcomeView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        VStack {
            
            ScrollView {
                
                Spacer()
                    .frame(height: 48)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image("tree-planting-1024")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(8)
                            .padding(2)
                            .background(Color.primary)
                            .cornerRadius(10)
                        Text("Welcome to \nPlant Doctor AI!")
                            .frame(height: 80)
                            .font(.title)
                            .bold()
                            .lineLimit(2)
                        
                        Spacer()
                    }.frame(alignment: .leading).padding(.top, -30)
                    
                    Spacer()
                        .frame(height: 25)
                    
                    tutorialTexts
                        .frame(alignment: .leading)
                    
                    Group {
                        Spacer()
                            .frame(height: 25)
                        Button(action: {
                            dismiss()
                        }) {
                            HStack{
                                Spacer()
                                Image(systemName: "arrowtriangle.forward.fill")
                                    .foregroundColor(.white)
                                    .font(.body)
                                Text("Start")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(15)
                            .background(.green)
                        }
                        .cornerRadius(10)
                        
                        
                        
                        externalResourcesLinks
                    }
                    
                    
                }.padding(.leading, 20).padding(.trailing, 20)
                
                Spacer()
            }
        }.onAppear(perform: saveTutorialShown)
    }
    
    var tutorialTexts: some View {
        VStack {
            Group {
                Spacer()
                    .frame(height: 25)
                Text("Your personal plant disease guide just arrived. Let's get you up to speed.")
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            Group {
                //
                Spacer()
                    .frame(height: 25)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                        .font(.body)
                        .padding(.bottom, 2)
                    Text("Disease recognition")
                        .font(.title3)
                        .bold()
                }
                
                Text("This app recognizes plant diseases from photos. Snap your plant or upload a picture from gallery — make sure it's close up, no clutter around.")
                    .padding(.top, -11)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            Group {
                Spacer()
                    .frame(height: 25)
                
                HStack {
                    Image(systemName: "cross.case")
                        .foregroundColor(.black)
                        .font(.body)
                        .padding(.bottom, 2)
                    Text("Treatment guidance")
                        .font(.title3)
                        .bold()
                }
                Text("Once the assessment is completed, you will see more information about the diagnosis, as well as tips for potential treament.")
                    .padding(.top, -11)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            Group {
                Spacer()
                    .frame(height: 25)
                
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.black)
                        .font(.body)
                        .padding(.bottom, 2)
                    Text("Disclaimer")
                        .font(.title3)
                        .bold()
                }
                Text("This app uses machine learning. By design, it will produce errors at times. Thus, results from the app should be taken as indicative. If necessary, please consult specialists.")
                    .padding(.top, -11)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    var externalResourcesLinks: some View {
        HStack {
            Spacer()
            
            Link("Terms & Conditions", destination: URL(string: "https://www.matyasbohacek.com/plant-doctor-ai/terms-and-conditions.pdf")!)
                .font(.caption)
                .foregroundColor(.green)
            Text("—")
                .font(.caption)
            Link("About ML Recognition ", destination: URL(string: "https://www.matyasbohacek.com/plant-doctor-ai/about-ml-recognition.pdf")!)
                .font(.caption)
                .foregroundColor(.green)
            Spacer()
            
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
                        .foregroundColor(.black)
                }
            }
            .padding(.top, 5)
            Spacer()
        }
    }
    
    private func saveTutorialShown() -> Void {
        UserDefaults.standard.set(true, forKey: "tutorial-shown")
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
