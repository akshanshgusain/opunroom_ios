//
//  LoginViewController.swift
//  opUndoor
//
//  Created by Akshansh Gusain on 27/06/20.
//  Copyright © 2020 akshanshgusain. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var emailString : String = ""
    var passwordString : String = ""
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgetPasswordTextField: UILabel!
    let BASE_URL = "https://dass.io/oppo/api/";
    let LOGIN = "user/login";
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clickop = UIGestureRecognizer(target: self, action: #selector(self.forgetPassClick))
        
        self.forgetPasswordTextField.addGestureRecognizer(clickop)
       
    }
    
    
    @IBAction func forgetPassClick(sender: UITapGestureRecognizer){
        print("clicked")
        let forgetPassVC = self.storyboard?.instantiateViewController(identifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        self.navigationController?.pushViewController(forgetPassVC, animated: true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @IBAction func signInButtonAction(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: "Please wait...")
        SVProgressHUD.setDefaultMaskType(.black)
        
        emailString = emailTextField.text!
        passwordString = passwordTextField.text!
        
        if(emailString.isEmpty){
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Email Empty", message: "Email/Username cannot be Empty", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default){
                                                  (action) in
                          self.dismiss(animated: true, completion: nil)
                                   }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else if(passwordString.isEmpty){
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Password Empty", message: "Password cannot be Empty", preferredStyle: .alert)
                       let action = UIAlertAction(title: "Ok", style: .default){
                                                             (action) in
                                     self.dismiss(animated: true, completion: nil)
                                              }
                       alert.addAction(action)
                       self.present(alert, animated: true, completion: nil)
        }
        else{
            //Make Newtwork Call
            print("sending email: \(emailTextField.text!) and Pass: \(passwordTextField.text!)")
            let params : [String : String] = ["username" : emailString,"password" : passwordString]
            getResponse(url: BASE_URL+LOGIN, parameters: params)
        }
        
        
        
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        let enterDetailsVC = self.storyboard?.instantiateViewController(identifier: "EnterDetailsViewController") as! EnterDetailsViewController
        self.navigationController?.pushViewController(enterDetailsVC, animated: true)
        
    }
    
//    @IBAction fun forgetPassordAction()
    
    //MARK: - Networking
    func getResponse(url: String, parameters: [String : String])
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
        let id = json["id"].stringValue
        let f_name = json["f_name"].stringValue
        let l_name = json["l_name"].stringValue
        let username = json["username"].stringValue
        let emailString = json["email"].stringValue
        let picture = json["picture"].stringValue
        let network = json["network"].stringValue
        let profession = json["profession"].stringValue
        let workEx = json["experience"].stringValue
        let current_company = json["current_company"].stringValue
        
        
        let action = UIAlertAction(title: "Ok", style: .default){
                                    (action) in
            self.dismiss(animated: true, completion: nil)
                     }
        
        if id != ""{
               print("Login Success")
            
            kUserDefault.set(emailString, forKey: EMAIL_KEY)
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
            
            SVProgressHUD.dismiss()
            
            loadMainVC()
            
        }
        else if id == ""{
                
                let alert = UIAlertController(title: "Invalid email or password", message: "Either the email ot he password is invalid", preferredStyle: .alert)
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
         
            SVProgressHUD.dismiss()
        }
    }

    
    //MARK: - Load New ViewController
       func loadMainVC(){
           let sb = UIStoryboard(name: "Main", bundle: nil)
           let vc = sb.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
          // vc.qrImg = createQRFromString(stringQR, size: CGSize(width: 240.0, height: 240.0))
           self.navigationController?.pushViewController(vc, animated: true)
       }
    
}
