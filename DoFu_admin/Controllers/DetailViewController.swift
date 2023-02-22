//
//  DetailViewController.swift
//  DoFu_admin
//
//  Created by Home on 21.02.2023.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {

    var selectedObject = ""
    var keyboardShowed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializing()
        
        print(selectedObject)
        
    }
    
    private func initializing() {
        // need to add hiding kb whet Return tapped - delegates for all of TF
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func tapTapped(_ sender: Any) {

        view.endEditing(true)
    }
}
