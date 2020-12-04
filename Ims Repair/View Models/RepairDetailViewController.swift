//
//  RepairDetailViewController.swift
//  Ims Repair
//
//  Created by Kevin Tierney on 11/23/20.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class RepairDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var company: UILabel!
    @IBOutlet var model: UILabel!
    @IBOutlet var brand: UILabel!
    @IBOutlet var sn: UILabel!
    @IBOutlet var issue: UILabel!
    @IBOutlet var status: UITextField!
    @IBOutlet var comptitle: UILabel!
    @IBOutlet var toolTitle: UILabel!
    @IBOutlet var pickerView: UIPickerView!
    
    var repairid : String  = ""
    var repairdetail = [repair]()
    let statusList = ["Initiated", "Quoted", "In Repair", "Repaired"]
    
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        status.delegate = self
        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
//    self.name.text = ""
//    self.email.text = ""
//    self.company.text = ""
//    self.model.text = ""
//    self.brand.text = ""
//    self.sn.text = ""
//    self.issue.text = ""
//    self.status.text = ""
//    self.toolTitle.text = ""
//    self.comptitle.text = ""
      loadrepair()
     
    }

    
    func loadrepair() {
        db.collection("Repairs").document(repairid).getDocument { (document, error) in
            if error == nil {
                if document != nil && document!.exists{
                 let repaired =  try? document?.data(as: repair.self)
                        self.name.text = repaired!.name
                    self.email.text = repaired!.email
                    self.company.text = repaired!.company
                    self.model.text = repaired!.model
                    self.brand.text = repaired!.brand
                    self.sn.text = repaired!.sn
                    self.issue.text = repaired!.issue
                    self.status.text = repaired!.status
                    self.comptitle.text = repaired?.company
                    self.toolTitle.text = repaired?.model
                    self.StatusColor()
                }
                else {
                    print(" no document")
                }
            }
        }
    }
    func updateStatus() {
        db.collection("Repairs").document(repairid).updateData(["status" : "\(self.status.text!)"]) { error in
            if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated")
                }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
   
    @IBAction func changeStatus(_ sender: Any) {
        if pickerView.isHidden {
            pickerView.isHidden = false
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return statusList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        status.text = statusList[row]
        StatusColor()
        updateStatus()
        pickerView.isHidden = true
        status.resignFirstResponder()
        
    }
    func StatusColor() {
        if status.text == "Initiated"{
            status.backgroundColor = .red
        }
        else if status.text == "Quoted" {
            status.backgroundColor = .orange
        }
        else if status.text == "In Repair" {
            status.backgroundColor = .yellow
        }
        else {
            status.backgroundColor = .green
        }
        
    }

}
