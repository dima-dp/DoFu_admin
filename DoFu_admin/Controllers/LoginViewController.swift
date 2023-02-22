//
//  ViewController.swift
//  DoFu_admin
//
//  Created by Home on 19.02.2023.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var keyboardShowed = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initializing()
    }
    
    
    private func initializing() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
      
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        if keyboardShowed == false {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                self.view.frame.origin.y -= keyboardHeight * 0.8
                keyboardShowed = true
            }
        }
    }
    
    @objc private func keyboardWillHide() {
        self.view.frame.origin.y = 0
        keyboardShowed = false
    }
    
    
    @IBAction func tapTapped(_ sender: Any) {
        
        view.endEditing(true)
    }
    

    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

