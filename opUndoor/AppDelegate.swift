//
//  AppDelegate.swift
//  SnapchatClone
//
//  Created by Akshansh Gusain on 22/06/20.
//  Copyright © 2020 akshanshgusain. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    static var standard: AppDelegate {
      return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
           if kUserDefault.bool(forKey: IS_LOGGEDIN)
           {
            print("Loading Home Controller")
            self.HomePageCall()
           }else{
            print("Loading Login View Controller")
            self.showLoginModule()
           }
    
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    }

//MARK: - Extension


extension AppDelegate {
  
    func showLoginModule() {
        print("showLoginModule called ")
        window?.rootViewController = nil
//        let storyBoard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
//        let navigationController = storyBoard.instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
//        window?.rootViewController = navigationController
        let loginVC = UIStoryboard.init(name: "LoginStoryboard", bundle: nil)
        let rootVC = loginVC.instantiateViewController(withIdentifier: "LoginNavigationController")
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
        
    }
    
    //Then Home page..
    func HomePageCall() {
        window?.rootViewController = nil
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyBoard.instantiateViewController(withIdentifier: "mainNavigationVC") as! UINavigationController
        window?.rootViewController = navigationController
    }
    

}


