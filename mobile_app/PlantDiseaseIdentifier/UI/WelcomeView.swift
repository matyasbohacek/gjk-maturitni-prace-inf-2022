//
//  WelcomeView.swift
//  PlantDiseaseIdentifier
//
//  Created by Matyáš Boháček on 17.02.2023.
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

struct WelcomeView: View {
    
    // MARK: State variables
    @Environment(\.dismiss) var dismiss
    
    // MARK: UI Components
    var body: some View {
        VStack {
            ScrollView {
                Spacer()
                    .frame(height: 48)
                VStack(alignment: .leading) {
                    titleHeaderView
                    Spacer()
                        .frame(height: 25)
                    tutorialTextsView
                        .frame(alignment: .leading)
                    Spacer()
                        .frame(height: 25)
                    startButton
                    externalResourcesLinksView
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                Spacer()
            }
        }
        .onAppear(perform: saveTutorialShown)
    }
    
    /// View containing the title and icon of the view
    var titleHeaderView: some View {
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
        }
        .frame(alignment: .leading)
        .padding(.top, -30)
    }
    
    /// Button that ends the tutorial and closes the modal (i.e., returns to the ContentView)
    var startButton: some View {
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
    }
    
    /// View containing the tutorial instructions
    var tutorialTextsView: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 25)
            Text("Your personal plant disease guide just arrived. Let's get you up to speed.")
            constructTutorialTextSection(systemIcon: "magnifyingglass", title: "Disease recognition", body: "This app recognizes plant diseases from photos. Snap your plant or upload a picture from gallery — make sure it's close up, no clutter around.")
            
            constructTutorialTextSection(systemIcon: "cross.case", title: "Treatment guidance", body: "Once the assessment is completed, you will see more information about the diagnosis, as well as tips for potential treament.")
            
            constructTutorialTextSection(systemIcon: "exclamationmark.triangle", title: "Disclaimer", body: "This app uses machine learning. By design, it will produce errors at times. Thus, results from the app should be taken as indicative. If necessary, please consult specialists.")
        }
        .padding(0)
    }
    
    /// View containing the links to relevant legal documents
    var externalResourcesLinksView: some View {
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
    
    // MARK: Methods
    
    /**
     Creates a section of the tutorial text instructions from the given content.
     
     - Parameter systemIcon: String with the system identifier of the desired section icon
     - Parameter title: String with the title of the section
     - Parameter body: String with the body of the section
     
     - Returns: VStack (within SwiftUI)
     */
    private func constructTutorialTextSection(systemIcon: String, title: String, body: String) -> some View {
        return VStack(alignment: .leading) {
            Spacer()
                .frame(height: 25)
            HStack {
                Image(systemName: systemIcon)
                    .foregroundColor(.black)
                    .font(.body)
                    .padding(.bottom, 2)
                Text(title)
                    .font(.title3)
                    .bold()
            }
            
            Text(body)
                .padding(.top, -11)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(0)
    }
    
    /**
     Notes that the tutorial has been presented so that it does not get shown again.
     
     - Returns: Does not return — saves this information into app's UserDefaults
     */
    private func saveTutorialShown() -> Void {
        UserDefaults.standard.set(true, forKey: "tutorial-shown")
    }
}

// MARK: Preview

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
