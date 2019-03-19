//
//  MapViewController.swift
//  Parkovka
//
//  Created by Leon Vladimirov on 1/26/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import UIKit
import MapKit
import AudioToolbox
class MapViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    private let methods = HelperMethods()
    private let location = LocationAndDate()

    
    var LocationText = ""
    var tappedOnEdit = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        let tapOnAddress = UITapGestureRecognizer.init(target: self, action: #selector(Edit))
        self.view.addGestureRecognizer(tapGesture)
        LocationLabel.addGestureRecognizer(tapOnAddress)
        mapView.delegate = self
        LocationEditTextField.delegate = self
        LocationEditTextField.text = "введите адрес"
        locate()
        
    }
    @objc func Edit() {
        tappedOnEdit = true
        LocationEditTextField.text = LocationLabel.text!
        LocationEditTextField.becomeFirstResponder()
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var LocationPointer: UIButton!
    @IBOutlet weak var LocationEditTextField: UITextField!
    @IBOutlet weak var InputView: InputView!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var LocateMeButton: UIButton!
    
    @IBAction func LocateMe(_ sender: UIButton) {
        // Called again in case connection appears.
        locate()
    }
    func locate() {
        let Currentlocation = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "latitude"), longitude: UserDefaults.standard.double(forKey: "longitude"))
        let span = MKCoordinateSpan(latitudeDelta: 0.0050, longitudeDelta: 0.0050)
        let region = MKCoordinateRegion (center:  Currentlocation, span: span)
        
        mapView.setRegion(region, animated: true)
        UpdateLocationTextField()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func UpdateLocationTextField() {
        if UserDefaults.standard.string(forKey: "Location") != nil {
            LocationText = UserDefaults.standard.string(forKey: "Location")!
        }
        LocationLabel.text = LocationText
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
       dismissKeyboard()
        return false
    }
    
    @IBAction func NextVC(_ sender: UIButton) {
        if !methods.CheckIfEmpty(text: LocationLabel.text!) {
            Report.shared.placeOfReport = LocationLabel.text!
            self.performSegue(withIdentifier: "ToCarInfo", sender: self)
        } else {
 
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !animated {
            let Location = CGPoint.init(x: LocationPointer.frame.midX, y: LocationPointer.frame.midY)
            let locationCoordinate = mapView.convert(Location, toCoordinateFrom: view)
            let pointerLocation = "\(location.GetLocationInfo(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude))"
            LocationLabel.text = pointerLocation
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        if !tappedOnEdit {
            textField.text = "" 
        }
        let myScreenRect: CGRect = UIScreen.main.bounds
        let keyboardHeight : CGFloat = 216
        
        UIView.beginAnimations( "animateView", context: nil)
        var needToMove: CGFloat = 0
        
        var frame : CGRect = self.view.frame
        if (InputView.frame.origin.y + InputView.frame.size.height + UIApplication.shared.statusBarFrame.size.height > (myScreenRect.size.height - keyboardHeight - 30)) {
            needToMove = (InputView.frame.origin.y + InputView.frame.size.height + UIApplication.shared.statusBarFrame.size.height) - (myScreenRect.size.height - keyboardHeight - 30)
        }
        
        frame.origin.y = -needToMove
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //move textfields back down
        if textField.text!.count != 0 {
            LocationLabel.text = textField.text!
        }
        
        UIView.beginAnimations( "animateView", context: nil)
        var frame : CGRect = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        UIView.commitAnimations()
        textField.text = ""
    }
}



  

