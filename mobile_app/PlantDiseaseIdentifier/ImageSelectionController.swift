//
//  ImageSelectionController.swift
//  PlantDiseaseIdentifier
//
//  Created by Matyáš Boháček on 20.11.2022.
//

import SwiftUI
import Foundation


struct ImageSelectionController: UIViewControllerRepresentable {
    
    @Binding var isPresenting: Bool
    @Binding var uiImage: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType
    
    typealias UIViewControllerType = UIImagePickerController
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(self)
    }
    
    class ImagePickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImageSelectionController
                
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.uiImage = info[.originalImage] as? UIImage
            parent.isPresenting = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresenting = false
        }
        
        init(_ imagePicker: ImageSelectionController) {
            self.parent = imagePicker
        }
    }
    
}
