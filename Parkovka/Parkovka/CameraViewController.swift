//
//  ViewController.swift
//  Parkovka
//
//  Created by Leon Vladimirov on 1/22/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class CameraViewController: UIViewController {

    private let LocationAndTimeData = LocationAndDate()
    private let methods = HelperMethods()
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var CaptureButton: UIButton!
    @IBOutlet weak var MenuButton: UIButton!
    @IBOutlet weak var Next: UIButton!
    @IBOutlet weak var CounterLabel: UILabel!
    
    var imageCounter = 0
    let UserWarningLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 500, height: 21))
    override func viewDidLoad() {
        startCamera()
  
        imageCounter = 0
        UserDefaults.standard.set(["ru"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        LocationAndTimeData.requestLocationUsage()
        LocationAndTimeData.findMyLocation()
        
        CounterLabel.text = "0/4"
        // We change the orientation of the label to force the user to go horizontal
        CounterLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        
        UserWarningLabel.textAlignment = .center
        UserWarningLabel.text = "Сделайте 4 фотографии машины, чтобы продолжить"
        UserWarningLabel.textColor = UIColor.white
        UserWarningLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        UserWarningLabel.frame.origin = CGPoint.init(x: self.view.frame.minX, y: self.view.frame.midY - (UserWarningLabel.frame.height / 2))
        
        self.view.layer.addSublayer(previewLayer)
        self.view.addSubview(CaptureButton)
        self.view.addSubview(MenuButton)
        self.view.addSubview(Next)
        self.view.addSubview(CounterLabel)
        
        self.view.addSubview(UserWarningLabel)
        UserWarningLabel.isHidden = true
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func NextVC(_ sender: UIButton) {
        
        if imageCounter >= 4 {
            if launchedBefore  {
                self.performSegue(withIdentifier: "InfoViewController", sender: self)
                
            } else {
                self.performSegue(withIdentifier: "FirstTimeLaunch", sender: self)
                
                UserDefaults.standard.set(true, forKey: "launchedBefore")
            }
            print(imageCounter)
            
        } else {
             UserWarningLabel.isHidden = false
             AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
    }
     
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    
    func startCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        cameraOutput = AVCapturePhotoOutput()
        
        if let device = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: device) {
            if (captureSession.canAddInput(input)) {
                captureSession.addInput(input)
                if (captureSession.canAddOutput(cameraOutput)) {
                    captureSession.addOutput(cameraOutput)
                   

                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    previewLayer.frame = self.view.layer.frame
                
                    
                    
                    captureSession.startRunning()
                }
            } else {
                print("issue here: captureSesssion.canAddInput")
            }
        } else {
            print("I have a problem: CameraViewController")
        }
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        imageCounter += 1
        CounterLabel.text = "\(imageCounter)/4"
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }
}




extension CameraViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            print("error occured : \(error.localizedDescription)")
        }
        
        if let dataImage = photo.fileDataRepresentation() {

           
            print(UIImage(data: dataImage)?.size as Any)
            
            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.up)
       
            Report.shared.images.append(image)

         
        } else {
            print("some error here")
        }
    }
    

}

