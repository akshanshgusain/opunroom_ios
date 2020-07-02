//
//  MiddleViewController.swift
//  SnapchatClone
//
//  Created by Akshansh Gusain on 22/06/20.
//  Copyright © 2020 akshanshgusain. All rights reserved.
//

import UIKit
import CameraManager



class MiddleViewController: UIViewController {
    let cameraManager = CameraManager()
    


    
    @IBOutlet weak var flashModeImageView: UIImageView!
    
   // @IBOutlet weak var outputImageView: UIButton!
    @IBOutlet weak var cameraSwitchImageView: UIImageView!//Flip Camera
    
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var askForPermissionLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    
    
    let darkBlue = UIColor(red: 4 / 255, green: 14 / 255, blue: 26 / 255, alpha: 1)
    let lightBlue = UIColor(red: 24 / 255, green: 125 / 255, blue: 251 / 255, alpha: 1)
    let redColor = UIColor(red: 229 / 255, green: 77 / 255, blue: 67 / 255, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraManager()
        
        navigationController?.navigationBar.isHidden = true
        
        askForPermissionLabel.isHidden = true
        askForPermissionLabel.backgroundColor = lightBlue
        askForPermissionLabel.textColor = .white
        askForPermissionLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(askForCameraPermissions))
        askForPermissionLabel.addGestureRecognizer(tapGesture)
        
        let currentCameraState = cameraManager.currentCameraStatus()
        if currentCameraState == .notDetermined {
            askForPermissionLabel.isHidden = false
        } else if currentCameraState == .ready {
            addCameraToView()
        } else {
            askForPermissionLabel.isHidden = false
        }
        
        if cameraManager.hasFlash {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeFlashMode))
            flashModeImageView.addGestureRecognizer(tapGesture)
            flashModeImageView.isUserInteractionEnabled = true
        }
        
        //outputImageView.image = UIImage(named: "output_video")
       // outputImageView.setTitle("output_video", for: .normal)
        //let outputGesture = UITapGestureRecognizer(target: self, action: #selector(outputModeButtonTapped))
        //outputImageView.addGestureRecognizer(outputGesture)
        
       // cameraTypeImageView.image = UIImage(named: "switch_camera")
        let cameraTypeGesture = UITapGestureRecognizer(target: self, action: #selector(changeCameraDevice))
        cameraSwitchImageView.addGestureRecognizer(cameraTypeGesture)
        cameraSwitchImageView.isUserInteractionEnabled = true
    }//End of viewdid Load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        cameraManager.resumeCaptureSession()
        cameraManager.startQRCodeDetection { result in
            switch result {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopQRCodeDetection()
        cameraManager.stopCaptureSession()
    }
    
    
    
    fileprivate func setupCameraManager() {
        cameraManager.shouldEnableExposure = false
        
        cameraManager.writeFilesToPhoneLibrary = true
        
        cameraManager.shouldFlipFrontCameraImage = false
        cameraManager.showAccessPermissionPopupAutomatically = false
        cameraManager.animateShutter = true
        
        cameraManager.cameraOutputMode = CameraOutputMode.stillImage
    }
    
    fileprivate func addCameraToView() {
        cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: CameraOutputMode.stillImage)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) -> Void in }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func changeFlashMode(_ sender: UIButton) {
        switch cameraManager.changeFlashMode() {
            case .off:
                flashModeImageView.image = UIImage(named: "ic_flash_off")
                
            case .on:
                flashModeImageView.image = UIImage(named: "ic_flash_on")
                
            case .auto:
                flashModeImageView.image = UIImage(named: "ic_flash_auto")
               
        }
    }
 

    @IBAction func recordButtonTapped(_ sender: UIButton) {
        switch cameraManager.cameraOutputMode {
            case .stillImage:
                cameraManager.capturePictureWithCompletion { result in
                    switch result {
                        case .failure:
                            self.cameraManager.showErrorBlock("Error occurred", "Cannot save picture.")
                        case .success(let content):
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageVC") as! ImageViewController
                            
                            if let validVC: ImageViewController = vc,
                                case let capturedData = content.asData {
                                print(capturedData!.printExifData())
                                let capturedImage = UIImage(data: capturedData!)!
                                validVC.image = capturedImage
                                validVC.cameraManager = self.cameraManager
                                print("Pushing VC")
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                    }
                }
            case .videoWithMic, .videoOnly:
                cameraButton.isSelected = !cameraButton.isSelected
                cameraButton.setTitle("", for: UIControl.State.selected)

                cameraButton.backgroundColor = cameraButton.isSelected ? redColor : lightBlue
                if sender.isSelected {
                    cameraManager.startRecordingVideo()
                } else {
                    cameraManager.stopVideoRecording { (_, error) -> Void in
                        if error != nil {
                            self.cameraManager.showErrorBlock("Error occurred", "Cannot save video.")
                        }
                    }
                }
        }
    }
    
//    @IBAction func outputModeButtonTapped(_ sender: UIButton) {
//        cameraManager.cameraOutputMode = cameraManager.cameraOutputMode == CameraOutputMode.videoWithMic ? CameraOutputMode.stillImage : CameraOutputMode.videoWithMic
//        switch cameraManager.cameraOutputMode {
//            case .stillImage:
//                cameraButton.isSelected = false
//                //cameraButton.backgroundColor = lightBlue
//                //outputImageView.image = UIImage(named: "output_image")
//                outputImageView.setTitle("output_image", for: .normal)
//            case .videoWithMic, .videoOnly:
//                //outputImageView.image = UIImage(named: "output_video")
//                outputImageView.setTitle("output_video", for: .normal)
//        }
//    }
    
    @IBAction func changeCameraDevice() {
        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
    }
    
    @IBAction func askForCameraPermissions() {
        cameraManager.askUserForCameraPermission { permissionGranted in
                
            if permissionGranted {
                self.askForPermissionLabel.isHidden = true
                self.askForPermissionLabel.alpha = 0
                self.addCameraToView()
            } else {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                } else {
                        // Fallback on earlier versions
                }
            }
        }
    }
        
//    @IBAction func changeCameraQuality() {
//        switch cameraManager.cameraOutputQuality {
//            case .high:
//                qualityLabel.text = "Medium"
//                cameraManager.cameraOutputQuality = .medium
//            case .medium:
//                qualityLabel.text = "Low"
//                cameraManager.cameraOutputQuality = .low
//            case .low:
//                qualityLabel.text = "High"
//                cameraManager.cameraOutputQuality = .high
//            default:
//                qualityLabel.text = "High"
//                cameraManager.cameraOutputQuality = .high
//            }
//        }
    
 
}

public extension Data {
func printExifData() {
    let cfdata: CFData = self as CFData
    let imageSourceRef = CGImageSourceCreateWithData(cfdata, nil)
    let imageProperties = CGImageSourceCopyMetadataAtIndex(imageSourceRef!, 0, nil)!
    
    let mutableMetadata = CGImageMetadataCreateMutableCopy(imageProperties)!
    
    CGImageMetadataEnumerateTagsUsingBlock(mutableMetadata, nil, nil) { _, tag in
        print(CGImageMetadataTagCopyName(tag)!, ":", CGImageMetadataTagCopyValue(tag)!)
        return true
    }
}
}
