//
//  ItemsViewController.swift
//  DoFu_admin
//
//  Created by Home on 19.02.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class ItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController()
    
    var ref: DatabaseReference!
    var items = Array<Items>()
    var filteredItems = Array<Items>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "items")
        initSearchController()
    }
    
    private func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // reading data from databese into Items array
        downloadItems()
        tableView.reloadData()
    }
    
    private func downloadItems() {
        ref.observe(.value) { [weak self] (snapshot) in
            var _items = Array<Items>()
            for item in snapshot.children {
                let item = Items(snapshot: item as! DataSnapshot)
                _items.append(item)
            }
            
            self?.items = _items
            self?.tableView.reloadData()
        }
    }
    
    // two methods below a user to delete table rows by sliding
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            guard let ref = item.ref else { return }
            let refImage = Storage.storage().reference().child("itemsFolder").child(item.nameEN)
            ref.removeValue()    // removing value
            refImage.delete()    // removing image
            downloadItems()      // refreshing data from database
            tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredItems.count
        }
        else {
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let itemsShape: Items!
        if searchController.isActive {
            itemsShape = filteredItems[indexPath.row]
        }
        else {
            itemsShape = items[indexPath.row]
        }
        
        cell.textLabel?.text = itemsShape.nameEN
        cell.textLabel?.textColor = .white
        return cell
    }
    
    
    // MARK -> Segue methods
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
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        let searchText = searchBar.text!
        
        filterForSearchText(searchText: searchText)
    }
    private func filterForSearchText(searchText: String) {
        filteredItems = items.filter
        {
            shape in
            if (searchController.searchBar.text != "") {
                let searchTextMatch = shape.nameEN.lowercased().contains(searchText.lowercased())
                
                return searchTextMatch
            }
            else {
                return false
            }
        }
        self.tableView.reloadData()
    }
}
