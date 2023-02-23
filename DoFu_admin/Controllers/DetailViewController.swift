//
//  DetailViewController.swift
//  DoFu_admin
//
//  Created by Home on 21.02.2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var image: UIImageView!
    
    var selectedObject = ""
    var keyboardShowed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializing()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        image.addGestureRecognizer(tap)
        image.isUserInteractionEnabled = true
        
        print(selectedObject)
        
    }
 
    @objc private func imageTapped() {
        print("ImageTapped!!!!!!!!!!!!!")
    }
    

    
    @IBAction func tapTapped(_ sender: Any) {

        view.endEditing(true)
    }
}
