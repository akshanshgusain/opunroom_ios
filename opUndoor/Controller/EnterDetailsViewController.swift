//
//  EnterDetailsViewController.swift
//  opUndoor
//
//  Created by Akshansh Gusain on 27/06/20.
//  Copyright © 2020 akshanshgusain. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class EnterDetailsViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var isUsernameAvailable: UILabel!
    let apiURL = "https://dass.io/oppo/api/user/checkusername";
    var isUsernameValid: Bool = false
             
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isUsernameAvailable.isHidden = true
    }
    @IBAction func signUpButton(_ sender: UIButton) {
        checkCredentials()
    }
    
    func checkCredentials(){
        let emaiAddress: String = emailTextField.text!
        let username: String = usernameTextField.text!
        let password: String = passwordTextField.text!
        let rePassword: String = rePasswordTextField.text!
        
        let action = UIAlertAction(title: "Ok", style: .default){
                                (action) in
        self.dismiss(animated: true, completion: nil)
        }
        
        if emaiAddress.isEmpty{
            let alert = UIAlertController(title: "Email Empty", message: "Email cannot be Empty", preferredStyle: .alert)
                    
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }else if username.isEmpty{
            let alert = UIAlertController(title: "Username Empty", message: "Username cannot be Empty", preferredStyle: .alert)
                    
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }else if password.isEmpty{
            let alert = UIAlertController(title: "Password Empty", message: "Password cannot be Empty", preferredStyle: .alert)
                    alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }else if rePassword.isEmpty{
            let alert = UIAlertController(title: "Verify password", message: "Eplease re-renter the password", preferredStyle: .alert)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else if password != rePassword{
            let alert = UIAlertController(title: "Invalid", message: "Password does not match", preferredStyle: .alert)
                alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else if !isUsernameValid{
            let alert = UIAlertController(title: "Not Available", message: "The username is not available", preferredStyle: .alert)
                alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else{
            //Send to next ViewController
            let enterDetails2VC = self.storyboard?.instantiateViewController(identifier: "EnterDetails2ViewController") as! EnterDetails2ViewController
            enterDetails2VC.email = emaiAddress
            enterDetails2VC.password = password
            enterDetails2VC.username = username
            self.navigationController?.pushViewController(enterDetails2VC, animated: true)
        }
         
    }
    
    func textFieldDidEndEditing(_ usernameTextField: UITextField) {
        if usernameTextField.tag == 1{
            //Check for userName
            let username: String = usernameTextField.text!
            let params:[String:String] = ["username" : username]
            restCall(url: apiURL, parameters: params)
        }
    }
    
    
    //MARK: - Networking
    func restCall(url: String, parameters: [String : String])
    {
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess{
                print("Got the response")
                let loginJSON : JSON = JSON(response.result.value!)
                self.dataParsing(json: loginJSON)
            }else{
                print("Error..\(String(describing: response.result.error))")
                SVProgressHUD.dismiss()
            }
        }
    }
    
    //MARK: - JSON Parsing
    func dataParsing(json: JSON)
    {
        let request_succesful = json["status"].stringValue
        let error = json["message"].stringValue
        
        print(request_succesful)
        print(error)
        
        if request_succesful == "1"{
               print("username available")
            
            isUsernameAvailable.isHidden = false
            isUsernameAvailable.text = "Username Available"
            isUsernameValid = true
            isUsernameAvailable.textColor = UIColor.green
            SVProgressHUD.dismiss()
            
        }
        else if request_succesful == "0"{
        print("username Unavailable")
            isUsernameAvailable.isHidden = false
            isUsernameAvailable.text = "Username Not Available"
            isUsernameValid = false
            isUsernameAvailable.textColor = UIColor.red
            SVProgressHUD.dismiss()
        }else{
            print(request_succesful)
            print(error)
        }
    }

}

