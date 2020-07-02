//
//  SettingsViewController.swift
//  opUndoor
//
//  Created by Akshansh Gusain on 01/07/20.
//  Copyright © 2020 akshanshgusain. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var displayPicture: UIImageView!
    @IBOutlet weak var editDisplayPicture: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    //picture, first name, lastname
    
    var firstNameString: String = ""
    var lastNameString: String = ""
    var profilePictureString: String = ""
    var idString: String = ""
    var usernameString: String = ""
    var emailString: String = ""
    var networkString: String = ""
    var professionString: String = ""
    var experienceString: String = ""
    var currentCompanyString: String = ""
    
    let apiURL = "https://dass.io/oppo/api/user/update"
   
    
    var isImageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
               self.displayPicture.isUserInteractionEnabled = true
               self.displayPicture.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.editDisplayPicture.isUserInteractionEnabled = true
        self.editDisplayPicture.addGestureRecognizer(tap2)
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        
        getUserDefaults()
    }
    
    
    func getUserDefaults(){
        firstNameString = kUserDefault.string(forKey: FIRST_NAME_KEY) ?? "First Name"
        lastNameString = kUserDefault.string(forKey: LAST_NAME_KEY) ?? "Last Name"
        profilePictureString = kUserDefault.string(forKey: PICTURE_KEY) ?? "First Name"
        
        idString = kUserDefault.string(forKey: ID_KEY) ?? "First Name"
        usernameString = kUserDefault.string(forKey: USER_NAME_KEY) ?? "First Name"
        emailString = kUserDefault.string(forKey: EMAIL_KEY) ?? "First Name"
        networkString = kUserDefault.string(forKey: NETWORK_KEY) ?? "First Name"
        
         professionString = kUserDefault.string(forKey: PROFESSION_KEY) ?? "First Name"
         experienceString = kUserDefault.string(forKey: WORK_EX_KEY) ?? "First Name"
         currentCompanyString = kUserDefault.string(forKey: CURRENT_COMPANY_KEY) ?? "First Name"
                  
        print("Email  \(emailString)")
           
        firstNameTextField.text = firstNameString
        lastNameTextField.text = lastNameString
           
           
         Alamofire.request(profilePictureString).responseImage { response in
               if let image = response.result.value {
                   self.displayPicture.image = image
               }
           }
           
       }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Tapped")
      ImagePickerManager().pickImage(self){ image in
        //here is the image
        
        self.displayPicture?.layer.cornerRadius = (self.displayPicture?.frame.size.width ?? 0.0) / 2
        self.displayPicture?.clipsToBounds = true
        self.displayPicture?.layer.borderWidth = 3.0
        self.displayPicture?.layer.borderColor = UIColor.black.cgColor
        self.displayPicture.image = image
        self.isImageSelected = true
      }
    }

    @IBAction func updateButton(_ sender: UIButton) {
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        
        let action = UIAlertAction(title: "Ok", style: .default){
                                       (action) in
               self.dismiss(animated: true, completion: nil)
               }
        if firstName.isEmpty{
                   let alert = UIAlertController(title: "Field Empty", message: "First Name cannot be Empty", preferredStyle: .alert)
                           
                   alert.addAction(action)
                   self.present(alert, animated: true, completion: nil)
                   
               }else if lastName.isEmpty{
                   let alert = UIAlertController(title: "Field Empty", message: "Last Name cannot be Empty", preferredStyle: .alert)
                           
                   alert.addAction(action)
                   self.present(alert, animated: true, completion: nil)
                   
        }else{
            //run Update logic
            
            let params:[String:String] = ["id":idString,"f_name":firstName, "l_name":lastName,"username":usernameString,"email":emailString,"network":"Opundoor","profession":professionString,"experience":experienceString,"current_company":currentCompanyString]
                
            print(params)
                restCall(url: apiURL, parameters: params)
            
             
        }
    }
    //MARK: - Networking
       func restCall(url: String, parameters: [String : String])
       {
        let imageDisplay = displayPicture.image
        let imageData = imageDisplay!.jpegData(compressionQuality: 0.2)!
        
        Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "picture",fileName: "file.jpg", mimeType: "image/jpg")
                for (key, value) in parameters {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    } //Optional for extra parameters
            },
        to: url)
        { (result) in
            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                
                })

                upload.responseJSON { response in
                    print(response.result.value!)
                    print("Success")

                    let  responseJson : JSON = JSON(response.result.value!)
                    self.dataParsing(json: responseJson)

                    }
               

            case .failure(let encodingError):
                print(encodingError)
                let action = UIAlertAction(title: "Ok", style: .default){
                                                  (action) in
                          self.dismiss(animated: true, completion: nil)
                                   }
                let alert = UIAlertController(title: "Error", message: "Some error has occured while updating your profile.Please try again", preferredStyle: .alert)
                               
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                
            }
         }
       }

    
    //MARK: - JSON Parsing
    func dataParsing(json: JSON)
    {
        let id = json["id"].stringValue
        let f_name = json["f_name"].stringValue
        let l_name = json["l_name"].stringValue
        let username = json["username"].stringValue
        let email = json["email"].stringValue
        let picture = json["picture"].stringValue
        let network = json["network"].stringValue
        let profession = json["profession"].stringValue
        let workEx = json["experience"].stringValue
        let current_company = json["current_company"].stringValue
        print("id = \(id)")
        
        if id != ""{
               print("Update Success")
            
            kUserDefault.set(email, forKey: EMAIL_KEY)
            kUserDefault.set(id, forKey: ID_KEY)
            kUserDefault.set(true, forKey: IS_LOGGEDIN)
            kUserDefault.set(f_name, forKey: FIRST_NAME_KEY)
            kUserDefault.set(l_name, forKey: LAST_NAME_KEY)
            kUserDefault.set(username, forKey: USER_NAME_KEY)
            kUserDefault.set(picture, forKey: PICTURE_KEY)
            kUserDefault.set(network, forKey: NETWORK_KEY)
            kUserDefault.set(profession, forKey: PROFESSION_KEY)
            kUserDefault.set(workEx, forKey: WORK_EX_KEY)
            kUserDefault.set(current_company, forKey: CURRENT_COMPANY_KEY)
            
            self.popCurrentVC()
            
        }
        else if id == ""{
            let action = UIAlertAction(title: "Ok", style: .default){
                                                             (action) in
                                     self.dismiss(animated: true, completion: nil)
                                              }
            let alert = UIAlertController(title: "Error", message: "Some error has occured while updating your profile.Please try again id==nil", preferredStyle: .alert)
                                          
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
    
        }
    }
    
    
    func popCurrentVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true);
    }
    
}
