//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Akshansh Gusain on 22/06/20.
//  Copyright © 2020 akshanshgusain. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var containerScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        injectSwipeViewControllers()
    }

    func injectSwipeViewControllers(){
        let left = self.storyboard?.instantiateViewController(withIdentifier: "left") as! LeftViewController
        self.addChild(left)
        self.containerScrollView.addSubview(left.view)
        self.didMove(toParent: self)
        
        let middle = self.storyboard?.instantiateViewController(withIdentifier: "middle") as! MiddleViewController
        self.addChild(middle)
        self.containerScrollView.addSubview(middle.view)
        self.didMove(toParent: self)
        
        var middleFrame: CGRect = middle.view.frame
        middleFrame.origin.x = self.view.frame.width
        middle.view.frame = middleFrame
        
        let right = self.storyboard?.instantiateViewController(withIdentifier: "right") as! RightViewController
        self.addChild(right)
        self.containerScrollView.addSubview(right.view)
        self.didMove(toParent: self)
        
        var rightFrame: CGRect = right.view.frame
        rightFrame.origin.x = 2 * self.view.frame.width
        right.view.frame = rightFrame
        
        self.containerScrollView.contentOffset = CGPoint(x: (self.view.frame.width) * 2, y:1)
        
        self.containerScrollView.contentSize = CGSize(width: (self.view.frame.width) * 3, height: (self.view.frame.height))
        
        
        
        
    }

}

