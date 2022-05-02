//
//  iOSImagePicker.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 28.03.22.
//

import SwiftUI
import CoreData

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    @Binding var selectedImageStore: ImageStore?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        private var viewContext: NSManagedObjectContext?

        init(_ parent: ImagePicker) {
            self.parent = parent
            let persistenceController = PersistenceController.shared
            viewContext = persistenceController.container.viewContext
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                if let orientedImage = image.fixOrientation() {
                    parent.selectedImage = orientedImage
                    let selectedImageData = orientedImage.pngData()
                    
                    if let imageStore = parent.selectedImageStore {
                        imageStore.image = selectedImageData
                        imageStore.updatedAt = Date()
                    }
                    else {
                        let imageStore = ImageStore(context: viewContext!)
                        imageStore.image = selectedImageData
                        imageStore.updatedAt = Date()
                        imageStore.createdAt = Date()
                        parent.selectedImageStore = imageStore
                    }
                }
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
