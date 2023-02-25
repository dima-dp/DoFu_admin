//
//  ItemsViewController.swift
//  DoFu_admin
//
//  Created by Home on 19.02.2023.
//

import UIKit
import Firebase

class ItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var items = Array<Items>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference(withPath: "items")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // reading data from databese into Items array
        ref.observe(.value) { [weak self] (snapshot) in
            var _items = Array<Items>()
            for item in snapshot.children {
                let item = Items(snapshot: item as! DataSnapshot)
                _items.append(item)
            }
            
            self?.items = _items
            self?.tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // ref.removeAllObservers()
    }
    
    // two methods below a user to delete table rows by sliding
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            item.ref?.removeValue()
            tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].nameEN
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _ = tableView.cellForRow(at: indexPath) else { return }
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let detailView = segue.destination as? DetailViewController
                // selectedObject will have info for nameEN - "primary key" for databesa
                detailView?.selectedObject = items[indexPath.row].nameEN
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    

    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
    }
    
    // MARK -> SIgn Out button tapped
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true)
    }
    
}
