//
//  ViewController.swift
//  Ims Repair
//
//  Created by Kevin Tierney on 11/16/20.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: self)
        }
    }
}

