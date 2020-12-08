//
//  UserProfileViewController.swift
//  Ims Repair
//
//  Created by Kevin Tierney on 12/7/20.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift


class UserProfileViewController: UIViewController {
    
    @IBOutlet var firstName: UILabel!
    @IBOutlet var lastName: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var userType: UILabel!
    
    
    let userID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    var userr = [users]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfile()
      
        }
    
    func loadProfile(){
        db.collection("Users").whereField("uid", isEqualTo: "\(userID!)").addSnapshotListener { (QuerySnapshot, error) in
            guard let documents = QuerySnapshot?.documents else{
                print("No Documents")
                return
            }
            self.userr = documents.compactMap({ (QueryDocumentSnapshot) -> users? in
                return try? QueryDocumentSnapshot.data(as: users.self)
            })
            let user = self.userr[0]
            self.firstName.text = user.fname
            self.lastName.text = user.lname
            self.email.text = user.email
            if (user.admin == true){
                self.userType.text = "Admin"
            }
            else{
                self.userType.text = "User"
            }
        }
    }
        // Do any additional setup after loading the view.
    }
