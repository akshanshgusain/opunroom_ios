//
//  RightViewController.swift
//  SnapchatClone
//
//  Created by Akshansh Gusain on 22/06/20.
//  Copyright © 2020 akshanshgusain. All rights reserved.
//

import UIKit
import Alamofire

class RightViewController: UIViewController {

    @IBOutlet weak var displayPicture: UIImageView!
    @IBOutlet weak var fullname: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                      self.displayPicture.isUserInteractionEnabled = true
                      self.displayPicture.addGestureRecognizer(tap)
        displayPicture.isUserInteractionEnabled = true
        getUserDetails()
    }
    
    func getUserDetails(){
        let imageURL = kUserDefault.string(forKey: PICTURE_KEY) ?? ""
        let name = kUserDefault.string(forKey: FIRST_NAME_KEY) ?? "No Name"
        
        fullname.text = "Hi, \(name)"
        
        Alamofire.request(imageURL).responseImage { response in
            if let image = response.result.value {
            self.displayPicture.image = image
            }
        }
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Clicked")
        
      let sb = UIStoryboard(name: "SettingsStoryboard", bundle: nil)
      let vc = sb.instantiateViewController(identifier: "ProfileViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
 
