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
        for tf in textFields {
            tf.delegate = self
        }
      
    }
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
