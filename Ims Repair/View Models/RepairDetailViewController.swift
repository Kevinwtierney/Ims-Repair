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
    
    @IBAction func deleteEntry(_ sender: Any){
        let alertController = UIAlertController(title: "Delete Entry", message: "Are you sure you want to delete this entry?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler:{ (action) -> Void in
            print("this entry has been deleted")
            self.deleteitem()
            self.navigationController?.popViewController(animated: true)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func deleteitem(){
        db.collection("Repairs").document(repairid).delete { (error) in
            if let error = error {
                print("error removing item \(error)")
            }
            else{
                print("document \(self.repairid) was sucessfully deleted" )
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
        status.inputView = pickerView
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
            status.backgroundColor = .purple
        }
        else {
            status.backgroundColor = .green
        }
        
    }

}
