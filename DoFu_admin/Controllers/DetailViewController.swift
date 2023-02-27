//
//  DetailViewController.swift
//  DoFu_admin
//
//  Created by Home on 21.02.2023.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    // textFields are using in extension to add delegates
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameUATF: UITextField!
    @IBOutlet weak var nameENTF: UITextField!
    @IBOutlet weak var costTF: UITextField!
    @IBOutlet weak var linkTF: UITextField!
    @IBOutlet weak var enabledSwitch: UISwitch!
    
    var ref: DatabaseReference!
    var items = Array<Items>()
    
    var selectedObject = ""
    var keyboardShowed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializing()
        
        // adding tap gesture to imageView to chose a picture
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        image.addGestureRecognizer(tap)
        image.isUserInteractionEnabled = true
        
        ref = Database.database().reference(withPath: "items")
        
        if selectedObject != "" {   // if selectedObject = 0 it means we tapped Add button on ItemsViewController
            // reading data from databese for selected item
            ref.child(selectedObject.lowercased()).observe(.value) { [weak self] snapshot in
                let item = Items(snapshot: snapshot)
                self?.nameENTF.text = item.nameEN
                self?.nameUATF.text = item.nameUA
                self?.costTF.text = item.cost
                self?.linkTF.text = item.link
                // self?.image
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if selectedObject != "" {   // if selectedObject = 0 it means we tapped Add button on ItemsViewController
            nameENTF.text = selectedObject
            nameENTF.isEnabled = false
            nameENTF.alpha = 0.9
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    //    ref.removeAllObservers()
    }
    
    // MARK -> Save button tapped
    @IBAction func saveTapped(_ sender: UIButton) {
        
        saveToDatabase()
        self.dismiss(animated: true)
    }
    
    private func saveToDatabase() {
        guard let link = linkTF.text else { return }
        if validateURL(withURL: link) == false {
            print("Wrong URL. Please, check it once more")
            return
        }
        // saving data to database - creating or updating
        guard let nameUA = nameUATF.text, let nameEN = nameENTF.text, let link = linkTF.text, let cost = costTF.text else { return }
        let item = Items(nameUA: nameUA, nameEN: nameEN, link: link, cost: cost, enabled: enabledSwitch.isOn)
        let itemRef = self.ref.child(item.nameEN.lowercased())
        itemRef.setValue(["nameUA": item.nameUA, "nameEN": item.nameEN, "link": item.link ?? "no link", "cost": item.cost, "enabled": item.enabled])
        
    }
    // MARK -> Validation - checking data in textFiels to be ok
    private func validateURL(withURL url: String) -> Bool {
        let regex = "http[s]?://(([^/:.[:space:]]+(.[^/:.[:space:]]+)*)|([0-9](.[0-9]{3})))(:[0-9]+)?((/[^?#[:space:]]+)([^#[:space:]]+)?(#.+)?)?"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = test.evaluate(with: url)
        return true
    }
    
    @objc private func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
        print("ImageTapped!!!!!!!!!!!!!")
    }
    
    @IBAction func tapTapped(_ sender: Any) {
        // hiding a keyboard
        view.endEditing(true)
    }
}




