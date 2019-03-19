//
//  TextFieldClass.swift
//  Parkovka
//
//  Created by Leon Vladimirov on 1/22/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import UIKit

class TextField: UITextField, UITextFieldDelegate {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        delegate = self
        createBorder()
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        createBorder()
    }
    
    func createBorder(){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.clearButtonMode = .whileEditing
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

}
