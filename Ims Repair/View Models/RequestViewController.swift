//
//  RequestViewController.swift
//  Ims Repair
//
//  Created by Kevin Tierney on 11/20/20.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage




class RequestViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var company: UITextField!
    @IBOutlet var brand: UITextField!
    @IBOutlet var model: UITextField!
    @IBOutlet var issue: UITextField!
    @IBOutlet var sn: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var submit: UIButton!
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let storageRef = StorageReference()
    let brands = ["Bosch", "Panasonic","Dessouter", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brand.delegate = self
        issue.delegate = self
        self.hideKeyboardWhenTappedAround()
        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func submitAction(_ sender: UIButton!) {
        sender.isUserInteractionEnabled = false
        var ref: DocumentReference? = nil
        ref = db.collection("Repairs").addDocument(data: [
            "name" : name.text!,"email" : email.text!,"company" : company.text!,"brand" : brand.text!,
            "model" : model.text!,"sn" : sn.text!,"issue" : issue.text!,"status" : "Initiated"
        ])
        { err in
            if let err = err {
                let alertController = UIAlertController(title: "REQUEST FAILED", message: "Check that all fields are filled in properly", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                print("Error adding document: \(err)")
            }
            else {
                self.savePDF()
                print("Document added with ID: \(ref!.documentID)")
              
                sender.isUserInteractionEnabled = true
                self.name.text = ""
                self.email.text = ""
                self.company.text = ""
                self.brand.text = ""
                self.model.text = ""
                self.sn.text = ""
                self.issue.text = ""
            }
        }
    }
    
    func savePDF() {
        let tempref = storageRef.child("templates/\(brand.text!).pdf")
        let filename = String(tempref.name) as NSString
        let documentsURL = FileManager.default.temporaryDirectory
        let localURL = documentsURL.appendingPathComponent("\(filename)")
        
        tempref.write(toFile: localURL) { url, error in
          if let error = error {
            print("\(error)")
          }
          else {
            print("succesful save of the pdf")
            self.presentActivityViewController(withUrl: url!)
          }
        }
    }
    func presentActivityViewController(withUrl url: URL) {
        DispatchQueue.main.async {
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.message, UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.markupAsPDF, UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.openInIBooks,
            UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.postToTwitter,
            UIActivity.ActivityType.mail,UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
            UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),]
            
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength : Int
        if(textField == issue){
            maxLength = 29
        }
        else{
            return false
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
    }
   
    
    @IBAction func selectBrand(_ sender: UITextField) {
        if pickerView.isHidden {
            pickerView.isHidden = false
            brand.inputView = pickerView
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return brands.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return brands[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        brand.text = brands[row]
        pickerView.isHidden = true
        brand.resignFirstResponder()
    }
    
    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
}
