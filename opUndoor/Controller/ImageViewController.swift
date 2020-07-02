//
//  ImageViewController.swift
//  SnapchatClone
//
//  Created by Akshansh Gusain on 22/06/20.
//  Copyright © 2020 akshanshgusain. All rights reserved.
//

import UIKit
import CameraManager

class ImageViewController: UIViewController {

    var image: UIImage?
    var cameraManager: CameraManager?
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false

        print("IMageViewController viewDidLoad")
        guard let validImage = image else {
            return
        }

        imageView.image = validImage

        if cameraManager?.cameraDevice == .front {
            switch validImage.imageOrientation {
            case .up, .down:
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            default:
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeButtonTapped(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }

}
