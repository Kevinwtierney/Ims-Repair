//
//  HomeViewController.swift
//  Ims Repair
//
//  Created by Kevin Tierney on 11/16/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet var repairTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var repairs = [repair]()
    var repairsSearch = [repair]()
    
    let db = Firestore.firestore()
    
    
    //This loads all of the view data on Load
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            repairTableView.refreshControl = refreshControl
            } else {
                repairTableView.backgroundView = refreshControl
            }
        searchBar.delegate = self
        self.hideKeyboardWhenTappedAround()
       
        repairTableView.dataSource = self
        repairTableView.delegate = self
        loadData()
    }
    
    // This function Loads data from firstore
    func loadData () {
        db.collection("Repairs").addSnapshotListener { (QuerySnapshot, Error) in
            guard let documents = QuerySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            self.repairs = documents.compactMap { (QueryDocumentSnapshot) -> repair? in
                return try? QueryDocumentSnapshot.data(as: repair.self)
            }
            self.repairsSearch = self.repairs
            DispatchQueue.main.async {
                self.repairTableView.reloadData()
            }
        }
    }
    
    
    // these functions load populate the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repairsSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Repair", for: indexPath)
        //let repairs = repairArraySearch[indexPath.row]
        let repaired = repairsSearch[indexPath.row]
        
        cell.textLabel!.text = repaired.company + " | " + repaired.model + " - " + repaired.sn
        
        return cell
    }
    
    // This prepares to show the detail view of the selected row
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "repairDetailsegue"{
                let destination = segue.destination as? RepairDetailViewController
                let index = repairTableView.indexPathForSelectedRow?.row
            destination?.repairid = repairsSearch[index!].id!
        }
    }

    //This is the function connected to the logout button
    @IBAction func logOutAction(_ sender: Any) {
        do{
            try
        Auth.auth().signOut()
        self.navigationController?.popToRootViewController(animated: true)
        }
        catch let signOutErrror as NSError {
           print("error signing out: %@", signOutErrror)
        }
    }
    
    // this is to navagate to the create repair screen from employee home screen
    @IBAction func createRepair() {
        self.performSegue(withIdentifier: "createRequest", sender: self)
    }
    
    //This is the function to lets the search bar operate properly
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            repairsSearch = repairs
            repairTableView.reloadData()
                return
            }
        repairsSearch = repairs.filter({ repair -> Bool in
            return repair.company.lowercased().contains(searchText.lowercased()) ||
                repair.model.lowercased().contains(searchText.lowercased()) ||
                repair.sn.lowercased().contains(searchText.lowercased())
            })
        repairTableView.reloadData()
    }

    //This Provides refresh functionallity
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        loadData()
        refreshControl.endRefreshing()
    }
}
