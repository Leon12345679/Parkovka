//
//  FinalProtocolViewController.swift
//  Parkovka
//
//  Created by Leon Vladimirov on 1/22/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import UIKit
import MessageUI

class FinalProtocolViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    private let LocationAndTimeData = LocationAndDate()
    private let methods = HelperMethods()
    var imageData = [Data]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ProtocolText.attributedText = CreateLoadProtocol()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func compressImages() {
        let images = Report.shared.images
        for image in images {
            imageData.append(image.jpegData(compressionQuality: 0.7)!)
        }
    }
    
    @IBOutlet weak var ProtocolText: UITextView!
    
    func Highlight(text: String, StringsToHighlight: [String]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string:text)
        for i in 0...StringsToHighlight.count - 1 {
            print(StringsToHighlight.count, i)
            let range = (text as NSString).range(of: StringsToHighlight[i])
            
        attributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.yellow, range: range)
        }
        return attributedString
    }
    
    func CreateLoadProtocol() -> NSAttributedString {
        var PlaceOfReport: String = Report.shared.placeOfReport
        // if managed to get geolocation data set
        if UserDefaults.standard.string(forKey: "Region") != nil {
            let currentAddress = Report.shared.placeOfReport
            let Region = UserDefaults.standard.string(forKey: "Region")
            let City = UserDefaults.standard.string(forKey: "City")
            PlaceOfReport = Region! + City! + currentAddress
        }
      
        let UserFriendlyDate = LocationAndTimeData.getTextDate()
        let Time = LocationAndTimeData.getTime()
        let PlateNumber = Report.shared.carNumber
        let CarModel = Report.shared.carModel
        let TypeOfViolation = Report.shared.typeOfViolation
        let CarNumberCode = Report.shared.carNumberCode
        let NameSurname = UserDefaults.standard.string(forKey: "Name")
        let PhoneNumber = UserDefaults.standard.string(forKey: "Phone")
        let SystemDate = LocationAndTimeData.getSystemDate()
        
        let text =
        """
        ЗАЯВЛЕНИЕ О ПРАВОНАРУШЕНИИ
        
        
        \(UserFriendlyDate) года в \(Time)  по
        адресу \(PlaceOfReport) мной обнаружен автомобиль, гос. номер \(PlateNumber), код региона \(CarNumberCode), марка и модель: \(CarModel), припаркованный с нарушениями ПДД: \(TypeOfViolation). Прошу проверить информацию и принять решение о возбуждении дела об административном правонарушении в соответствии со статьей 28.1 КоАП РФ. Со статьей 306 УК РФ о заведомо ложном доносе ознакомлен. Смысл статьи 51 Конституции РФ о необязательности свидетельствовать против
        себя и своих родственников мне понятен.
        
        
        Прошу уведомить меня о результате рассмотрения моего заявления в
        установленные законом сроки.
        
        
        Дополнительно прошу уведомить меня о решении по делу об
        административном правонарушении, после вынесения постановления.
        
        
        \(NameSurname!)
        Контактный телефон: \(PhoneNumber!)
        
        \(SystemDate)
        """
        
        return Highlight(text: text, StringsToHighlight: [PlateNumber, TypeOfViolation, PlaceOfReport, CarModel, NameSurname!, PhoneNumber!, CarNumberCode])
    }
    
    
    @IBAction func SendReport(_ sender: UIButton) {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([UserDefaults.standard.string(forKey: "Email")!, "moderation.parkovka@gmail.com"])
        mailComposerVC.setSubject("Заявление об административном правонарушении")
        mailComposerVC.setMessageBody("\(ProtocolText.text!)", isHTML: false)
        
        // unpacking images from array and attaching them to Email
        compressImages()
        var dataName = 0
        for data in imageData {
            mailComposerVC.addAttachmentData(data, mimeType: "image/png", fileName: "\(dataName).png")
            dataName += 1
            
        }
        
        return mailComposerVC
    
    }
    
    
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send Email.  Please check Email configuration and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    var CanSegue: Bool = false
    // MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            CanSegue = true
            // Clear images from Report - all other info is overwritten 
            Report.shared.images.removeAll()
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(error?.localizedDescription ?? "nil")")
        }
        if CanSegue {
            self.performSegue(withIdentifier: "EmailDidSend", sender: self)
        }
        controller.dismiss(animated: true)
        
    }
    
    
}
