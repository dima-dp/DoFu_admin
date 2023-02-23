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
        
        print(selectedObject)
    }
    
   
    
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let nameUA = nameUATF.text, let nameEN = nameENTF.text, let link = linkTF.text, let cost = costTF.text else { return }
        let item = Items(nameUA: nameUA, nameEN: nameEN, link: link, cost: cost, enabled: enabledSwitch.isOn)
        let itemRef = self.ref.child(item.nameEN.lowercased())
        itemRef.setValue(["nameUA": item.nameUA, "nameEN": item.nameEN, "link": item.link ?? "no link", "cost": item.cost, "enabled": item.enabled])
    }
    
    @objc private func imageTapped() {
        print("ImageTapped!!!!!!!!!!!!!")
    }
    

    
    @IBAction func tapTapped(_ sender: Any) {

        view.endEditing(true)
    }
}
