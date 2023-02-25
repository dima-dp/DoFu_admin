//
//  Extension DetailViewController.swift
//  DoFu_admin
//
//  Created by Home on 23.02.2023.
//

import UIKit

extension DetailViewController: UITextFieldDelegate {
    // MARK -> Here I add methods to show/hide keyboard
    
    func initializing() {
        image.layer.cornerRadius = 20
        
        // adding delegates to textFields
        for tf in textFields {
            tf.delegate = self
        }
        
    }
    // hiding keyboard when Return is tapped
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
    
    // MARK -> imagePickerMethods
    extension DetailViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let choosenImage = info[.originalImage] as! UIImage
            image.image = choosenImage
            dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true)
        }
}
