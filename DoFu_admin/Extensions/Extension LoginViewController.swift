//
//  Extension UIViewController.swift
//  DoFu_admin
//
//  Created by Home on 23.02.2023.
//


// MARK -> Here are methods for working with keyboard - showung/hiding it and moving content under keyboard
import UIKit
import Firebase

extension LoginViewController: UITextFieldDelegate  {
    
    func initializing() {
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
        
        warningLabel.alpha = 0
        Auth.auth().addStateDidChangeListener({ [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: "itemsSegue", sender: nil)
            }
        })
    }

    @objc func keyboardWillShow(notification: Notification) {
        
        if keyboardShowed == false {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                self.view.frame.origin.y -= keyboardHeight * 0.8
                keyboardShowed = true
            }
        }
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
        keyboardShowed = false
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    

}
