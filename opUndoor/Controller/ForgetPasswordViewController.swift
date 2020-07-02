//
//  ForgetPasswordViewController.swift
//  opUndoor
//
//  Created by Akshansh Gusain on 27/06/20.
//  Copyright © 2020 akshanshgusain. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    let apiURL: String = "https://dass.io/oppo/api/user/forgotpassword"
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func resetPasswordButton(_ sender: UIButton) {
        let emailString: String = emailTextField.text!
        
        let action = UIAlertAction(title: "Ok", style: .default){
                                       (action) in
               self.dismiss(animated: true, completion: nil)
        }
        
        
        if emailString.isEmpty{
            
            let alert = UIAlertController(title: "Field Empty", message: "Please your registered Email adress", preferredStyle: .alert)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else{
            
            let params:[String:String] = ["email" : emailString]
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
        
        let action = UIAlertAction(title: "Ok", style: .default){
                                       (action) in
               self.dismiss(animated: true, completion: nil)
               }
        let action2 = UIAlertAction(title: "Ok", style: .default){
                                              (action) in
                      self.sendToRoot()
                      }
        
          let request_succesful = json["status"].stringValue
          let error = json["message"].stringValue
          
          print(request_succesful)
          print(error)
          
          if request_succesful == "1"{
              let alert = UIAlertController(title: "Sent", message: "Email reset link has been sent to your email", preferredStyle: .alert)
               alert.addAction(action2)
               self.present(alert, animated: true, completion: nil)
              
          }else{
            let alert = UIAlertController(title: "Invalid Email", message: "No such Email Exist", preferredStyle: .alert)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    
    }
    func sendToRoot(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}
