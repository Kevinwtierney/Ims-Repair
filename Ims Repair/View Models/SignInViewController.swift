//
//  SignInViewController.swift
//  Ims Repair
//
//  Created by Kevin Tierney on 11/16/20.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var email:
    UITextField!
    @IBOutlet var password:
    UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.delegate = self
        self.hideKeyboardWhenTappedAround() 
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "loggedin", sender: self)
        }
    }
    
    @IBAction func sigInAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!,password: password.text!) { (user, error) in
            if error == nil {
                self.performSegue(withIdentifier: "signInToHome", sender: self)
            }
            else {
                let alertController = UIAlertController(title: "Login fail", message: "email, password combination not correct", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                self.navigationController?.popViewController(animated: true)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        password.resignFirstResponder()
        return true
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
