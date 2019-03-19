//
//  InfoViewController.swift
//  Parkovka
//
//  Created by Leon Vladimirov on 1/22/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import UIKit
import AudioToolbox

class InfoViewController: UIViewController, UITextFieldDelegate {
    
    private let methods = HelperMethods()
    override func viewDidLoad() {

        CarNumber.delegate = self
        CarModel.delegate = self
        CarNumberCode.delegate = self
        CarNumber.tag = 0
        CarNumberCode.tag = 1
        CarModel.tag = 2
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        CarNumber.becomeFirstResponder()
      
        super.viewDidLoad()
    }
    
    @IBOutlet weak var CarNumber: UITextField!
    @IBOutlet weak var CarModel: UITextField!
    @IBOutlet weak var CarNumberCode: UITextField!
    @IBOutlet weak var CarNumberLabel: UILabel!
    @IBOutlet weak var CarNumberCodeLabel: UILabel!
    @IBOutlet weak var CarModelLabel: UILabel!
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }

        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        //move textfields up
        // Change back to black if attempted to segue with incorrect format data
        CarNumberLabel.textColor = UIColor.black
        CarNumberCodeLabel.textColor = UIColor.black
        CarModelLabel.textColor = UIColor.black
        
        let myScreenRect: CGRect = UIScreen.main.bounds
        let keyboardHeight : CGFloat = 216
        
        UIView.beginAnimations( "animateView", context: nil)
        var _:TimeInterval = 0.35
        var needToMove: CGFloat = 0
        
        var frame : CGRect = self.view.frame
        if (textField.frame.origin.y + textField.frame.size.height + UIApplication.shared.statusBarFrame.size.height > (myScreenRect.size.height - keyboardHeight - 30)) {
            needToMove = (textField.frame.origin.y + textField.frame.size.height + UIApplication.shared.statusBarFrame.size.height) - (myScreenRect.size.height - keyboardHeight - 30);
        }
        
        frame.origin.y = -needToMove
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case CarNumber:
            Report.shared.carNumber = CarNumber.text!
            
        case CarNumberCode:
            Report.shared.carNumberCode = CarNumberCode.text!
            
        case CarModel:
            Report.shared.carModel = CarModel.text!
            
        default:
            break
        }
        
        //move textfields back down
        UIView.beginAnimations( "animateView", context: nil)
        var _:TimeInterval = 0.35
        var frame : CGRect = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    
    @IBAction func NextVC(_ sender: UIButton) {

        if methods.CheckCarNumberFormat(CarNumber: CarNumber.text!) && methods.CheckCarNumberCode(CarNumberCode: CarNumberCode.text! ) && !methods.CheckIfEmpty(text: CarModel.text!){
        self.performSegue(withIdentifier: "TypeOfViolation", sender: self)
        } else {
            if !methods.CheckCarNumberFormat(CarNumber: CarNumber.text!) {
                CarNumberLabel.textColor = UIColor.red
            }
            if !methods.CheckCarNumberCode(CarNumberCode: CarNumberCode.text!) {
                CarNumberCodeLabel.textColor = UIColor.red
            }
            if methods.CheckIfEmpty(text: CarModel.text!) {
                CarModelLabel.textColor = UIColor.red
            }
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}

