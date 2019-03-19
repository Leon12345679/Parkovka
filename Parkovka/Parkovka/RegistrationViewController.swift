//
//  RegistrationViewController.swift
//  Parkovka
//
//  Created by Leon Vladimirov on 1/22/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import UIKit
import AudioToolbox

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    private let methods = HelperMethods()
    override func viewDidLoad() {
        Name.delegate = self
        Email.delegate = self
        Phone.delegate = self
        
        Name.text =  UserDefaults.standard.string(forKey: "Name")
        Email.text = UserDefaults.standard.string(forKey: "Email")
        Phone.text = UserDefaults.standard.string(forKey: "Phone")
        
        Name.tag = 0
        Email.tag = 1
        Phone.tag = 2
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        super.viewDidLoad()
    }
    @IBOutlet weak var Name: TextField!
    @IBOutlet weak var Email: TextField!
    @IBOutlet weak var Phone: TextField!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var PhoneLabel: UILabel!
    
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
        NameLabel.textColor = UIColor.black
        EmailLabel.textColor = UIColor.black
        PhoneLabel.textColor = UIColor.black
        //move textfields up
        let myScreenRect: CGRect = UIScreen.main.bounds
        let keyboardHeight : CGFloat = 216
        
        UIView.beginAnimations("animateView", context: nil)
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
        case Name:
            if !methods.CheckIfEmpty(text: Name.text!) {
                print("Wrote Name to userdefaults")
                UserDefaults.standard.set(Name.text, forKey: "Name")
            }
            
        case Email:
            if !methods.CheckIfEmpty(text: Email.text!) {
                print("Wrote Email to userdefaults")
                UserDefaults.standard.set(Email.text, forKey: "Email")
            }
            
        case Phone:
            if !methods.CheckIfEmpty(text: Phone.text!) {
                print("Wrote Phone to userdefaults")
                UserDefaults.standard.set(Phone.text, forKey: "Phone")
            }
            
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
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")

    @IBAction func NextVC(_ sender: UIButton) {
        if !methods.CheckIfEmpty(text: Name.text!) && methods.CheckIfValidEmail(email: Email.text!) && methods.CheckIfValidPhone(phone: Phone.text!){
            
        
        if launchedBefore  {
            self.performSegue(withIdentifier: "BackToCamera", sender: self)
        } else {
            self.performSegue(withIdentifier: "ToInfo", sender: self)
            
        }
        } else {
            if methods.CheckIfEmpty(text: Name.text!) {
                NameLabel.textColor = UIColor.red
            }
            
            if !methods.CheckIfValidEmail(email: Email.text!) {
                EmailLabel.textColor = UIColor.red
            }
            
            if !methods.CheckIfValidPhone(phone: Phone.text!) {
                PhoneLabel.textColor = UIColor.red
            }
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    

    
}
