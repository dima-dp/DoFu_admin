//
//  ViewController.swift
//  DoFu_admin
//
//  Created by Home on 19.02.2023.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var keyboardShowed = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initializing()
    }
    
    // MARK -> Hiding keyboard
    @IBAction func tapTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    // MARK -> Displaying warning label with different text
    private func displayWarningLabel(withText text: String) {
        warningLabel.text = text
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
            [weak self] in
            self?.warningLabel.alpha = 1
        }) { [weak self] complete in
            self?.warningLabel.alpha = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        view.endEditing(true)   // hidina a keyboard
        
        // checking email and password fields to not be blank
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        // authorisation with Firebase
        Auth.auth().signIn(withEmail: email, password: password) { [weak self]  (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Error occured")
                return
            }
            if user != nil {
                self?.performSegue(withIdentifier: "itemsSegue", sender: nil)
                return
            }
            self?.displayWarningLabel(withText: "No such user")
        }
    }
    
    // MARK -> register button. Is disabled - amin-user can't create himself
    @IBAction func registerTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Access Denied", message: "You are not allowed to register", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alertController, animated: true)
     /*   guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            if error == nil {
                if user != nil {
                    self?.performSegue(withIdentifier: "itemsSegue", sender: nil)
                }
            }
        }*/
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

