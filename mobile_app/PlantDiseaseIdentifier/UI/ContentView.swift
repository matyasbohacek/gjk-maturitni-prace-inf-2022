//
//  ContentView.swift
//  PlantDiseaseIdentifier
//
//  Created by Matyáš Boháček on 20.11.2022.
//
//
//  REFERENCES — Documentation, Code Reference, Forums
//
//    - seefood, available https://github.com/theleonwei/seefood/blob/main/SeeFood/ContentView.swift – this resource was later used as reference during debugging
//
//  REFERENCES — Libraries
//
//    (None)
//

import SwiftUI
import Photos
import AVKit
import AVFoundation

struct ContentView: View {
    
    // MARK: State variables
    @State var showingImageSelectionController: Bool = false
    @State var showingSheet = false
    
    @State var showingAboutView = false
    @State var showingWelcomeView = !UserDefaults.standard.bool(forKey: "tutorial-shown")
    
    @State var showingPhotoAccessAlert = false
    @State var showingDatabaseErrorAlert: Bool
    @State var showingUnknownDiagnosisAlert = false
    
    @State var uiImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    // MARK: Observed objects
    @ObservedObject var classifier: ObservableImageDiseaseClassifierWrapper
    @ObservedObject var manager: ObservableDatabaseLoadingWrapper
    
    // MARK: UI Components
    var body: some View {
        VStack {
            headerView
            mainSelectedImageView
            classificationResultsView
            actionButtonsPane
        }
        .sheet(isPresented: $showingImageSelectionController){
            selectionView
        }
        .sheet(isPresented: $showingAboutView) {
            AboutView()
        }
        .sheet(isPresented: $showingWelcomeView) {
            WelcomeView()
        }
        .alert("Permission denied", isPresented: $showingPhotoAccessAlert, actions: {
            Button("OK", role: .cancel, action: {})
        }, message: {
            Text("In the past, you denied us from accessing your Photo Gallery or Camera. To use this option, go to Settings, find this app (Plant Doctor AI), and grant the necessary permissions.")
        })
        .alert("Error: Faulty database", isPresented: $showingDatabaseErrorAlert, actions: {
            Button("OK", role: .cancel, action: {})
        }, message: {
            Text("An error occurred during database loading, and some of the app's functionalities may be limited. To fix this, reinstall the app, please. If the issue persists, contact the author.")
        })
        .alert("Error: Unknown diagnosis", isPresented: $showingUnknownDiagnosisAlert, actions: {
            Button("OK", role: .cancel, action: {})
        }, message: {
            Text("The diagnosis, as predicted by the model, is not found in the database. To fix this, reinstall the app, please. If the issue persists, contact the author.")
        })
        .padding()
    }
    
    /// Header view containing the app's logo, title, and a button that opens the AboutView
    var headerView: some View {
        HStack {
            Text("Plant Doctor AI")
                .foregroundColor(Color.green)
                .font(.title)
                .bold()
            Spacer()
            Button(action: {
                showingAboutView.toggle()
            }) {
                HStack{
                    Image(systemName: "info")
                        .foregroundColor(.white)
                        .font(.body)
                }
                .padding(15)
                .background(.green)
            }
            .cornerRadius(10)
            .frame(width: 18, height: 18)
        }
        .frame(alignment: .leading).padding(.trailing, 15)
    }
    
    /// Center view with the selected input image
    var mainSelectedImageView: some View {
        ZStack (alignment: .top) {
            RoundedRectangle(cornerSize: CGSize(width: 16, height: 16))
                .strokeBorder(lineWidth: 2)
                .foregroundColor(.black)
                .frame(maxHeight: .infinity)
                .overlay(
                    Group {
                        if uiImage != nil {
                            Image(uiImage: uiImage!)
                                .resizable()
                                .scaledToFill()
                                .fixedSize(horizontal: false, vertical: true)
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                                .cornerRadius(15)
                                .mask(LinearGradient(gradient: Gradient(colors: [.clear, Color.white, Color.white, Color.white]), startPoint: .top, endPoint: .bottom))
                        }
                    }
                ).clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            if uiImage != nil {
                clearButtonComponentView
            } else {
                getStartedTipsView
            }
        }.padding(.bottom, 1)
    }
    
    /// Bottom view containing the classification results and a button that opens the DiseaseDetailModal
    var classificationResultsView: some View {
        HStack {
            VStack (alignment: .leading) {
                Text("Recognized plant (and disease):")
                    .font(.footnote)
                Spacer()
                    .frame(height: 5)
                if classifier.imageClass != nil && uiImage != nil {
                    if manager.data.keys.contains(classifier.imageClass!) {
                        Text(manager.data[classifier.imageClass!]!.name)
                            .bold()
                    } else {
                        Text("Unknown diagnosis")
                            .bold()
                    }
                } else {
                    Text("N/A")
                        .bold()
                }
            }.padding(.leading, 15)
            
            if classifier.imageClass != nil && uiImage != nil {
                Group {
                    Spacer()
                    Button(action: {
                        if let imageClass = classifier.imageClass {
                            if manager.data.keys.contains(imageClass) {
                                showingSheet.toggle()
                            } else {
                                // TODO:
                                showingUnknownDiagnosisAlert = true
                            }
                        } else {
                            // TODO:
                            showingUnknownDiagnosisAlert = true
                        }
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.black)
                            .font(.title2)
                            .padding(15)
                    }
                    .sheet(isPresented: $showingSheet) {
                        DiseaseDetailModal(presentedPlantDisease: manager.data[classifier.imageClass!]!)
                    }
                    
                }
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 80)
        .background(Color(UIColor.systemGray4))
        .cornerRadius(16)
    }
    
    /// Footer view containing the input selection buttons, which open the camera or photo gallery for input image selection
    var actionButtonsPane: some View {
        HStack {
            Button(action: {
                sourceType = .photoLibrary
                if readyToShowSelectionController() {
                    showingImageSelectionController = true
                } else {
                    showingPhotoAccessAlert = true
                }
            }) {
                HStack{
                    Spacer()
                    Image(systemName: "photo")
                        .foregroundColor(.white)
                        .font(.body)
                    Text("Gallery")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(15)
                .background(.green)
            }
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
            
            Button(action: {
                sourceType = .camera
                if readyToShowSelectionController() {
                    showingImageSelectionController = true
                } else {
                    showingPhotoAccessAlert = true
                }
            }) {
                HStack{
                    Spacer()
                    Image(systemName: "camera")
                        .foregroundColor(.white)
                        .font(.body)
                    Text("Camera")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(15)
                .background(.green)
            }
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
    
    /// Button that clears the image selection
    var clearButtonComponentView: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        uiImage = nil
                    }
                }) {
                    Text("Clear image")
                        .foregroundColor(.black)
                        .padding(.trailing, 10)
                }
            }
            .padding(.top, 10)
            Spacer()
        }
    }
    
    /// View wih the input image selection mechanism
    var selectionView: some View {
        ImageSelectionController(isPresenting: $showingImageSelectionController, uiImage: $uiImage, sourceType: $sourceType)
            .onDisappear{
                if uiImage != nil {
                    withAnimation {
                        classifier.classify(image: uiImage!)
                    }
                }
            }
    }
    
    /// View containing tips for getting started, shown if no image is selected
    var getStartedTipsView: some View {
        VStack {
            Spacer()
            VStack{
                HStack {
                    Image("image-96")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                        .padding(5)
                    Image(systemName: "arrow.right")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 20, height: 16)
                        .padding(5)
                    Image("pass-fail-96")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                        .padding(5)
                }.padding(.bottom, 6)
                Text("Start by taking a new photo\nor selecting one from your gallery.")
                    .font(.footnote)
                    .padding([.leading, .trailing], 20)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
    }
    
    // MARK: Methods
    
    /**
     Determines whether all necessary permissions have been granted in order to open the camera or camera roll for input image selection.
     
     - Returns: Bool representing desired image source readiness
     */
    func readyToShowSelectionController() -> Bool {
        if sourceType == .photoLibrary && PHPhotoLibrary.authorizationStatus() != .authorized {
            return false
        } else if sourceType == .camera && AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
            return false
        } else {
            return true
        }
    }
    
    init(classifier: ObservableImageDiseaseClassifierWrapper) {
        self.classifier = classifier
        uiImage = nil
        do {
            manager = try ObservableDatabaseLoadingWrapper(fileURL: Bundle.main.url(forResource: "plantvillage-database", withExtension: "csv")!)
            showingDatabaseErrorAlert = false
        } catch {
            manager = ObservableDatabaseLoadingWrapper()
            showingDatabaseErrorAlert = true
        }
    }
    
}

// MARK: Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(classifier: ObservableImageDiseaseClassifierWrapper())
    }
}
