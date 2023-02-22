//
//  DetailViewController.swift
//  DoFu_admin
//
//  Created by Home on 21.02.2023.
//

import UIKit

class DetailViewController: UIViewController {

    var selectedObject = ""
    var keyboardShowed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(selectedObject)
        
    }
    
    
    @IBAction func tapTapped(_ sender: Any) {

        view.endEditing(true)
    }
}
