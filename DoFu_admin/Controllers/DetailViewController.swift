//
//  DetailViewController.swift
//  DoFu_admin
//
//  Created by Home on 21.02.2023.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var image: UIImageView!
    
    var selectedObject = ""
    var keyboardShowed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializing()
        
        print(selectedObject)
        
    }
    
    private func initializing() {
        for tf in textFields {
            tf.delegate = self
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        image.addGestureRecognizer(tap)
        image.isUserInteractionEnabled = true
    }
    @objc private func imageTapped() {
        print("ImageTapped!!!!!!!!!!!!!")
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func tapTapped(_ sender: Any) {

        view.endEditing(true)
    }
}
