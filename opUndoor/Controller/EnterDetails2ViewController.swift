//
//  EnterDetails2ViewController.swift
//  opUndoor
//
//  Created by Akshansh Gusain on 27/06/20.
//  Copyright © 2020 akshanshgusain. All rights reserved.
//

import UIKit

class EnterDetails2ViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var dpImageView: UIImageView!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var profession: UITextField!
    
    @IBOutlet weak var workEx: UITextField!
    
    
    
    
    @IBOutlet weak var currentCompanyTextField: UITextField!
    
    var email: String = ""
    var username: String = ""
    var password: String = ""
    
    var selectedProfession: String = ""
    var selectedWorkExp: String = ""

    var isImageSelected: Bool = false

    
    let pickerProfession: [String] = ["Computers and Technology", "Health Care and Allied Health", "IEducation and Social Services", "Arts and Communications", "Trades and Transportation", "Management, Business, and Finance", "Architecture and Civil Engineering","Hospitality, Tourism, and the Service Industry", "Law and Law Enforcement", "Other"]
    
     let pickerExperience: [String] = ["1-2 Years", "2-5 Years", "5-10 Years", "10+ Years"]
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(email)  \(username) \(password)")
        
        self.profession.delegate = self
        self.workEx.delegate = self
        createPickerView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.dpImageView.isUserInteractionEnabled = true
        self.dpImageView.addGestureRecognizer(tap)
        
        
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        finalizeRegistration()
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Tapped")
      ImagePickerManager().pickImage(self){ image in
        //here is the image
        
        self.dpImageView?.layer.cornerRadius = (self.dpImageView?.frame.size.width ?? 0.0) / 2
        self.dpImageView?.clipsToBounds = true
        self.dpImageView?.layer.borderWidth = 3.0
        self.dpImageView?.layer.borderColor = UIColor.black.cgColor
        self.dpImageView.image = image
        self.isImageSelected = true
      }
    }
    
    
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.tag = 1
        profession.inputView = pickerView
        
        let pickerView2 = UIPickerView()
        pickerView2.delegate = self
        pickerView2.tag = 2
        workEx.inputView = pickerView2
        
    }
    

    
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
        
        
        let button4 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        
       toolBar.setItems([button4], animated: true)
       toolBar.isUserInteractionEnabled = true
        profession.inputAccessoryView = toolBar
        
        let toolBar2 = UIToolbar()
              toolBar2.sizeToFit()
               
               
               let button5 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
               
              toolBar2.setItems([button5], animated: true)
              toolBar2.isUserInteractionEnabled = true
        workEx.inputAccessoryView = toolBar2
    }
    @objc func action() {
          view.endEditing(true)
    }
    
    
    
    //Picker Protocol stubs
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return pickerProfession.count
        }else{
            return pickerExperience.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return pickerProfession[row]
        }else{
            return pickerExperience[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            selectedProfession = pickerProfession[row]
            profession.text = selectedProfession
            print(selectedProfession)
            dismissPickerView()
        }else{
            selectedWorkExp = pickerExperience[row]
            workEx.text = selectedWorkExp
            print(selectedWorkExp)
            dismissPickerView()
        }
        
        
    }
    
    func textFieldDidEndEditing(_ usernameTextField: UITextField) {
        self.profession.resignFirstResponder()
    }
    
    
    func finalizeRegistration(){
        let firstName = firstNameTextField.text!
        let lasttName = lastNameTextField.text!
        let professionString = profession.text!
        let workExString = workEx.text!
        
        let action = UIAlertAction(title: "Ok", style: .default){
                                       (action) in
               self.dismiss(animated: true, completion: nil)
        }
        
        if firstName.isEmpty{
            let alert = UIAlertController(title: "Field Empty", message: "First Name cannot be Empty", preferredStyle: .alert)
                    
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }else if lasttName.isEmpty{
            let alert = UIAlertController(title: "Field Empty", message: "Last Name cannot be Empty", preferredStyle: .alert)
                    
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else if professionString.isEmpty{
            let alert = UIAlertController(title: "Field Empty", message: "Field of work cannot be Empty", preferredStyle: .alert)
                    
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else if workExString.isEmpty{
            let alert = UIAlertController(title: "Field Empty", message: "Work Experience cannot be Empty", preferredStyle: .alert)
                    
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }else if !self.isImageSelected{
            let alert = UIAlertController(title: "Field Empty", message: "Please select a display picture", preferredStyle: .alert)
                               
                       alert.addAction(action)
                       self.present(alert, animated: true, completion: nil)
        }else{
            let finalVC = self.storyboard?.instantiateViewController(identifier: "TransitionViewController") as! TransitionViewController
            finalVC.displayImage = self.dpImageView.image!
            finalVC.email = self.email
            finalVC.username = self.username
            finalVC.password = self.password
            finalVC.selectedProfession = self.selectedProfession
            finalVC.selectedWorkExp = self.selectedWorkExp
            finalVC.firstName = firstName
            finalVC.lastName = lasttName
            finalVC.currentCompany = self.currentCompanyTextField.text ?? ""
            self.navigationController?.pushViewController(finalVC, animated: true)
        }
    }
    
}

