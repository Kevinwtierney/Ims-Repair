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
    var emailAdd: UITextField!
    
    
    let userID = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    var userr = [users]()
    var currentemail = Auth.auth().currentUser?.email

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
    
    @IBAction func resetPassword(){
        let alertController = UIAlertController(title: "Password Reset", message: "Password reset instructions will be sent to your email.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Your password was reset")
                    self.resetPasswordEmail()
                    self.signOut()
                })
                alertController.addAction(defaultAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
        }
    
    func resetPasswordEmail(){
        Auth.auth().sendPasswordReset(withEmail: currentemail!) { error in
            if let error = error {
                print("\(error)")
            }
            else {
                print("The email was sent sucessfully")
            }
         }
      }
    
    @IBAction func changeEmail() {
        let alertController = UIAlertController(title: "Email Reset", message: "Submit your desired email address", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let defaultAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            print("Your email has been changed")
            self.resetEmail()
            self.signOut()
        })
        defaultAction.isEnabled = false
        alertController.addTextField(configurationHandler: {(textField:UITextField!) in
            textField.placeholder = "Enter Email"
            self.emailAdd = textField
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { (notification) in
                defaultAction.isEnabled = textField.text!.isEmail()
                   }
        })
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func resetEmail(){
        Auth.auth().currentUser?.updateEmail(to: self.emailAdd.text!, completion: { (Error) in
            if  let Error = Error{
                print ("\(Error)")
            }
            else{
                print("email was changed succesfully")
            }
        })
    }
    
    func signOut(){
        do{
            try
        Auth.auth().signOut()
        self.navigationController?.popToRootViewController(animated: true)
        }
        catch let signOutErrror as NSError {
           print("error signing out: %@", signOutErrror)
        }
    }
}
extension String {
    func isEmail()->Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}
    
    
