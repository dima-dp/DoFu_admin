//
//  Items.swift
//  DoFu_admin
//
//  Created by Home on 23.02.2023.
//

import Foundation
import Firebase

struct Items {
    let ref: DatabaseReference?
    let nameUA: String
    let nameEN: String
    let link: String?
    let cost: String
    var enabled: Bool
    
   // var image: UIImage?
    
    init(nameUA: String, nameEN: String, link: String?, cost: String, enabled: Bool) {
        self.nameUA = nameUA
        self.nameEN = nameEN
        self.link = link
        self.cost = cost
        self.enabled = enabled
        //self.image = image
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        nameUA = snapshotValue["nameUA"] as! String
        nameEN = snapshotValue["nameEN"] as! String
        link = snapshotValue["link"] as! String
        cost = snapshotValue["cost"] as! String
        enabled = snapshotValue["enabled"] as! Bool
        //image = snapshotValue["image"] as! UIImage
        ref = snapshot.ref
        
    }
}
