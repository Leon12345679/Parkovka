//
//  FormatCheckingFunctions.swift
//  Parkovka
//
//  Created by Leon Vladimirov on 1/23/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import UIKit

class HelperMethods {
    
    // Used in RegistrationViewController
    func CheckIfValidPhone(phone: String) -> Bool {
        let allowedChar = ["+","0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        var string: String = phone
        string = phone.replacingOccurrences(of: " ", with: "")
        var valid: Bool = true
        
        if string.count != 0 {
        for char in string {
            
            if !allowedChar.contains(String(char)) {
                valid = false
            }
        }
        } else {
            valid = false
        }
        return valid
    }
    
    func CheckIfValidEmail(email: String) -> Bool {
        var string: String = email
        string = email.replacingOccurrences(of: " ", with: "")
        let allowedChar = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", allowedChar)
        return emailTest.evaluate(with: string)
    }
    
    // Used in all user input requires viewcontrollers    
    func CheckIfEmpty(text: String) -> Bool{
        var empty: Bool = true
        var string: String = text
        string = text.replacingOccurrences(of: " ", with: "")
        if string.count != 0  {
            empty = false
        }
        
        return empty
    }
    
    // Used in InfoViewController
    func CheckCarNumberCode(CarNumberCode: String) -> Bool {
        var CodeAllowed = true
        var CodeString = CarNumberCode
        let allowedCharList = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        CodeString = CarNumberCode.replacingOccurrences(of: " ", with: "")
        if CodeString.count <= 3 {
            for char in CodeString {
                if !allowedCharList.contains(String(char)) {
                    CodeAllowed = false
                    break
                }
            }
        } else {
           CodeAllowed = false
        }
        
        return CodeAllowed
    }
    
    func CheckCarNumberFormat(CarNumber: String) -> Bool {
        var CarNumberString = CarNumber.uppercased()
        CarNumberString = CarNumberString.replacingOccurrences(of: " ", with: "")
        
        let allowedCharList = ["А", "В", "Е", "К", "М", "Н", "О", "Р", "С", "Т", "У", "Х", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "B", "E", "H", "K", "O","A","C", "Y", "M"]
        var NumberAllowed: Bool = true
        
        if CarNumberString.count == 6 {
            for char in CarNumberString {
                if !allowedCharList.contains(String(char)) {
                    NumberAllowed = false
                    break
                }
            }
        } else {
            NumberAllowed = false
        }
        return NumberAllowed
    }

}
