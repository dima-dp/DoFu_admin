//
//  DetailViewController.swift
//  DoFu_admin
//
//  Created by Home on 21.02.2023.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        image.addGestureRecognizer(tap)
        image.isUserInteractionEnabled = true
        
        ref = Database.database().reference(withPath: "items")
        
        if selectedObject != "" {
            
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
        if selectedObject != "" {
            nameENTF.text = selectedObject
            nameENTF.isEnabled = false
            nameENTF.alpha = 0.9
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    //    ref.removeAllObservers()
    }
    
    
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        saveToDatabase()
        self.dismiss(animated: true)
    }
    
    private func saveToDatabase() {
        
        if validation() == false {
            print("Wrong information")
            return
        }
        
        guard let nameUA = nameUATF.text, let nameEN = nameENTF.text, let link = linkTF.text, let cost = costTF.text else { return }
        let item = Items(nameUA: nameUA, nameEN: nameEN, link: link, cost: cost, enabled: enabledSwitch.isOn)
        let itemRef = self.ref.child(item.nameEN.lowercased())
        itemRef.setValue(["nameUA": item.nameUA, "nameEN": item.nameEN, "link": item.link ?? "no link", "cost": item.cost, "enabled": item.enabled])
        
    }
    
    private func validation() -> Bool {
        return true
        
        
    }
    @objc private func imageTapped() {
        print("ImageTapped!!!!!!!!!!!!!")
    }
    
    @IBAction func tapTapped(_ sender: Any) {
        
        view.endEditing(true)
    }
}
