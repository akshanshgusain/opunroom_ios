//
//  ProfileViewController.swift
//  opUndoor
//
//  Created by Akshansh Gusain on 01/07/20.
//  Copyright © 2020 akshanshgusain. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class ProfileViewController: UIViewController {

    @IBOutlet weak var displayPicture: UIImageView!
    @IBOutlet weak var editProfileButton: UIImageView!
    @IBOutlet weak var fullNameTextField: UILabel!
    @IBOutlet weak var usernameTextField: UILabel!
    @IBOutlet weak var professionTextField: UILabel!
    @IBOutlet weak var backButton: UIImageView!
    
    var firstNameString: String = ""
    var lastNameString: String = ""
    var usernameNameString: String = ""
    var profilePictureString: String = ""
    var professionString: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleBack(_:)))
                      self.backButton.isUserInteractionEnabled = true
                      self.backButton.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleSettings(_:)))
        self.editProfileButton.isUserInteractionEnabled = true
        self.editProfileButton.addGestureRecognizer(tap2)
        
        getUserDefaults()

    }
    
    @objc func handleBack(_ sender: UITapGestureRecognizer) {
        print("Back")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSettings(_ sender: UITapGestureRecognizer) {
           print("Setting")
        let vc = self.storyboard?.instantiateViewController(identifier: "SettingsViewController") as! SettingsViewController
           self.navigationController?.pushViewController(vc,animated: true)
       }
    
    
    func getUserDefaults(){
        firstNameString = kUserDefault.string(forKey: FIRST_NAME_KEY) ?? "First Name"
               lastNameString = kUserDefault.string(forKey: LAST_NAME_KEY) ?? "Last Name"
               usernameNameString = kUserDefault.string(forKey: USER_NAME_KEY) ?? "userName"
               profilePictureString = kUserDefault.string(forKey: PICTURE_KEY) ?? "First Name"
               professionString = kUserDefault.string(forKey: PROFESSION_KEY) ?? "profession"
        
        fullNameTextField.text = "\(firstNameString) \(lastNameString)"
        usernameTextField.text = usernameNameString
        professionTextField.text = professionString
        
      Alamofire.request(profilePictureString).responseImage { response in
            if let image = response.result.value {
                self.displayPicture.image = image
            }
        }
        
    }
    
    

    @IBAction func logoutButton(_ sender: UIButton) {
        //logout here
        let domain = Bundle.main.bundleIdentifier!
        kUserDefault.removePersistentDomain(forName: domain)



        print(kUserDefault.dictionaryRepresentation().count)
        
        let sb = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
