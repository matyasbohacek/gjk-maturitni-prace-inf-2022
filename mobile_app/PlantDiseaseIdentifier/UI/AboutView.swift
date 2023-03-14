//
//  AboutView.swift
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

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            VStack {
                
                ScrollView {
                    
                    Spacer()
                        .frame(height: 48)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image("info-1024")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(8)
                            .padding(2)
                            .background(Color.primary)
                            .cornerRadius(10)
                        Text("About")
                            .frame(height: 80)
                            .font(.title)
                            .bold()
                            .lineLimit(2)
                        
                        Spacer()
                    }.frame(alignment: .leading).padding(.top, -30)
                    
                    Spacer()
                        .frame(height: 25)
                    
                    texts
                        .frame(alignment: .leading)
                    
                }.padding(.leading, 20).padding(.trailing, 20)
                
                Spacer()
                
                }
            }
            closeButton
        }
    }
    
    var texts: some View {
        VStack {
            Group {
                Spacer()
                    .frame(height: 25)
                Text("This app was created as the final project for secondary school-leaving exam in Computer Science by Matyáš Boháček at Johannes Kepler Grammar School in Prague.")
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            Group {
                //
                Spacer()
                    .frame(height: 25)
                
                HStack {
                    Image(systemName: "books.vertical")
                        .foregroundColor(.black)
                        .font(.body)
                        .padding(.bottom, 2)
                    Text("Resources & Libraries")
                        .font(.title3)
                        .bold()
                }
                
                Group {
                    HStack {
                        Link("PyTorch", destination: URL(string: "https://pytorch.org/")!)
                            .foregroundColor(.green)
                        Text("— MIT License")
                    }
                    HStack {
                        Link("SwiftCSV", destination: URL(string: "https://github.com/swiftcsv/SwiftCSV")!)
                            .foregroundColor(.green)
                        Text("— MIT License")
                    }
                    HStack {
                        Link("PlantVillage Dataset", destination: URL(string: "https://arxiv.org/abs/1511.08060v2")!)
                            .foregroundColor(.green)
                        Text("— CC0 1.0")
                    }
                }.padding(.top, -11)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            Group {
                Spacer()
                    .frame(height: 25)
                
                HStack {
                    Image(systemName: "hand.raised")
                        .foregroundColor(.black)
                        .font(.body)
                        .padding(.bottom, 2)
                    Text("Safety & Privacy")
                        .font(.title3)
                        .bold()
                }
                Group {
                    Link("Terms & Conditions", destination: URL(string: "https://www.matyasbohacek.com/plant-doctor-ai/terms-and-conditions.pdf")!)
                        .foregroundColor(.green)
                    Link("Privacy Policy", destination: URL(string: "https://www.matyasbohacek.com/plant-doctor-ai/privacy-policy.pdf")!)
                        .foregroundColor(.green)
                    Link("About ML Recognition", destination: URL(string: "https://www.matyasbohacek.com/plant-doctor-ai/about-ml-recognition.pdf")!)
                        .foregroundColor(.green)
                }.padding(.top, -11)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            Group {
                Spacer()
                    .frame(height: 25)
                
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.black)
                        .font(.body)
                        .padding(.bottom, 2)
                    Text("Contact")
                        .font(.title3)
                        .bold()
                }
                Group {
                    Link("E-mail", destination: URL(string: "mailto:matyas.bohacek@matsworld.io")!)
                        .foregroundColor(.green)
                    Link("Twitter", destination: URL(string: "https://twitter.com/matyas_bohacek")!)
                        .foregroundColor(.green)
                    Link("GitHub", destination: URL(string: "https://github.com/matyasbohacek")!)
                        .foregroundColor(.green)
                }.padding(.top, -11)
            }.frame(maxWidth: .infinity, alignment: .leading)
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
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
