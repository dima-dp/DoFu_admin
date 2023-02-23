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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "This is cell #\(indexPath.row)"
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let detailView = segue.destination as? DetailViewController
                detailView?.selectedObject = "\(indexPath)"
                self.tableView.deselectRow(at: indexPath, animated: true)
            }  
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
    }
    
    
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
