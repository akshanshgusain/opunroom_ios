//
//  ImagePickerManager.swift
//  LawyerDairy
//
//  Created by NovoStack Private Limited on 31/01/19.
//  Copyright © 2019 Ashwani Kumar. All rights reserved.
//

import UIKit

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController()
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?
    
    override init(){
        super.init()
        self.picker.allowsEditing = true
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        
        let gallaryAction = UIAlertAction(title: "Gallary", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
   
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
      // For Swift 4.2
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var imagex : UIImage!

        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            imagex = img

        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imagex = img
        }
        
          picker.dismiss(animated: true, completion: nil)
        
//          guard let image = info[.originalImage] as? UIImage else {
//              fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//          }
          pickImageCallback?(imagex)
      }
    
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
    
}

