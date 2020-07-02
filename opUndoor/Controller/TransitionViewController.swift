//
//  TransitionViewController.swift
//  opUndoor
//
//  Created by Akshansh Gusain on 01/07/20.
//  Copyright © 2020 akshanshgusain. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import SVProgressHUD

class TransitionViewController: UIViewController {
    
    var displayImage: UIImage? = nil
    var email: String = ""
    var username: String = ""
    var password: String = ""
    var selectedProfession: String = ""
    var selectedWorkExp: String = ""
    
    var firstName: String = ""
    var lastName: String = ""
    var currentCompany: String = ""
    let apiEndpoint: String = "https://dass.io/oppo/api/user/register"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        print("\(email)  \(email)  \(username) \(password)  \(selectedProfession)  \(selectedWorkExp) \(currentCompany) \(String(describing: displayImage))")
        
        let params:[String:String] = ["f_name":firstName, "l_name":lastName,"username":username,"email":email,"password":password,"network":"Opundoor","profession":selectedProfession,"experience":selectedWorkExp,"current_company":currentCompany]
        
        restCall(url: apiEndpoint, parameters: params)
        
    }
    
    
    //MARK: - Networking
       func restCall(url: String, parameters: [String : String])
       {
        let imageData = displayImage!.jpegData(compressionQuality: 0.2)!
        
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
                    SVProgressHUD.show(withStatus: "Please wait...")
                    SVProgressHUD.setDefaultMaskType(.black)
                
                })

                upload.responseJSON { response in
                    print(response.result.value!)
                    print("Success")
                    SVProgressHUD.dismiss()
                   let  responseJson : JSON = JSON(response.result.value!)
                    if responseJson["status"].stringValue == "1"{
                        
                        let action = UIAlertAction(title: "Ok", style: .default){
                                                       (action) in
                               self.sendToRoot()
                               }
                        let alert = UIAlertController(title: "Account Registered", message: "A verification link has been sent your email address. Verifiy your account and login.", preferredStyle: .alert)
                                   alert.addAction(action)
                                   self.present(alert, animated: true, completion: nil)
                        
                    }
                }

            case .failure(let encodingError):
                print(encodingError)
                print("Failure")
                SVProgressHUD.dismiss()
                let action = UIAlertAction(title: "Ok", style: .default){
                                                                      (action) in
                                              self.sendToRoot()
                                              }
                let alert = UIAlertController(title: "Account Not Registered", message: "Something went wrong.", preferredStyle: .alert)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
       }
    
    func sendToRoot(){
        self.navigationController?.popToRootViewController(animated: true)
    }

}
