//
//  DetailViewController.swift
//  DoFu_admin
//
//  Created by Home on 21.02.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import SkeletonView

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
        
       
        
        if selectedObject != "" {   // if selectedObject != "" it means we tapped existing item in previous screen
            
            for tf in textFields {
                tf.isSkeletonable = true
                tf.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .wetAsphalt), transition: .crossDissolve(0.25))
            }
            image.isSkeletonable = true
            image.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .wetAsphalt), transition: .crossDissolve(0.25))
           
            
            // reading data from databese for selected item
            ref.child(selectedObject.lowercased()).observe(.value) { [weak self] snapshot in
                
                let item = Items(snapshot: snapshot)
                for tf in self!.textFields {
                    tf.stopSkeletonAnimation()
                    tf.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                }
                
                self?.nameENTF.text = item.nameEN
                self?.nameUATF.text = item.nameUA
                self?.costTF.text = item.cost
                self?.linkTF.text = item.link
                
            }
            // downloading image
            let refImage = Storage.storage().reference().child("itemsFolder").child(selectedObject.lowercased())
            refImage.getData(maxSize: Int64(1024 * 1024 * 500)) { [weak self]  (data, error) in
                guard let imageData = data else { return }
                let image = UIImage(data: imageData)
                
                self?.image.stopSkeletonAnimation()
                self?.image.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                self?.image.image = image
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
    }
    
    // MARK -> Save button tapped
    @IBAction func saveTapped(_ sender: UIButton) {
        
        saveToDatabase()
        self.dismiss(animated: true)
    }
    
    private func saveToDatabase() {
        guard let link = linkTF.text else { return }
        if validateURL(withURL: link) == false {
            let alert = UIAlertController(title: "Link error", message: "Invalid link", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // saving data to database - creating or updating
        guard let nameUA = nameUATF.text, let nameEN = nameENTF.text, let link = linkTF.text, let cost = costTF.text else { return }
        self.uploadImage(itemName: nameEN.lowercased(), photo: self.image.image!) { (result) in
            switch result {
            case .success(let url):
                let item = Items(nameUA: nameUA, nameEN: nameEN, link: link, cost: cost, image: url.absoluteString, enabled: self.enabledSwitch.isOn)

                let itemRef = self.ref.child(item.nameEN.lowercased())
                
                itemRef.setValue(["nameUA": item.nameUA, "nameEN": item.nameEN, "link": item.link, "cost": item.cost, "image": item.image, "enabled": item.enabled])
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
    // MARK -> Validation - checking data in textFiels to be ok
    private func validateURL(withURL url: String) -> Bool {
        let regex = "http[s]?://(([^/:.[:space:]]+(.[^/:.[:space:]]+)*)|([0-9](.[0-9]{3})))(:[0-9]+)?((/[^?#[:space:]]+)([^#[:space:]]+)?(#.+)?)?"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = test.evaluate(with: url)
        return result
    }
    
    @objc private func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    private func uploadImage(itemName: String, photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        
        let ref = Storage.storage().reference().child("itemsFolder").child(itemName)
        guard let imageData = photo.jpegData(compressionQuality: 0.4) else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        ref.putData(imageData, metadata: metadata) { metadata, error in
            guard metadata != nil else {
                completion(.failure(error!))
                return
            }
            ref.downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
    }
    
    @IBAction func tapTapped(_ sender: Any) {
        // hiding a keyboard
        view.endEditing(true)
    }
}




