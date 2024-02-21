//
//  AddBuddyView.swift
//  PaudhaUI
//
//  Created by user1 on 19/02/24.
//

import SwiftUI
import UIKit

struct AddBuddyView: View {
    @EnvironmentObject var plantCollection: PlantCollection
    @State private var buddyNickname = ""
    @State private var buddyType = ""
    @State private var selectedImage: UIImage?
    @State private var tempSelectedImage: UIImage?
    @State private var showImagePicker = false
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField("Buddy Nickname", text: $buddyNickname)
                .padding()

            TextField("Buddy Type", text: $buddyType)
                .padding()

            Button(action: {
                showImagePicker = true
            }) {
                Text("Select Image")
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker1(selectedImage: $tempSelectedImage, isImagePickerPresented: $showImagePicker)
            }

            if let selectedImage = tempSelectedImage ?? selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }

            Button("Save Buddy") {
                if let selectedImage = tempSelectedImage {
                    let imageName = UUID().uuidString
                    saveImageToDocumentDirectory(image: selectedImage, imageName: imageName)
                    plantCollection.plants.append(Plant(imageName: imageName, nickname: buddyNickname, type: buddyType))
                    buddyNickname = ""
                    buddyType = ""
                    tempSelectedImage = nil
                    showImagePicker = false
                    
                    
                    presentationMode.wrappedValue.dismiss()

                    // Print statements
                    print("Image saved to document directory")
                    print("New Plant added to collection: \(plantCollection.plants.last)")
                }
            }

            .padding()
        }
        .padding()
    }

    // Function to save image to the document directory
    func saveImageToDocumentDirectory(image: UIImage, imageName: String) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let filename = getDocumentsDirectory().appendingPathComponent(imageName)
            try? data.write(to: filename)
        }
    }
    
    


    // Function to get the documents directory path
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
