//
//  TextField.swift
//  Parkovka
//
//  Created by Leon Vladimirov on 3/17/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import UIKit

class InputView: UIView {
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 18
        self.dropShadow(color: UIColor.black, offSet: CGSize(width: -1, height: 1), radius: 7, scale: true)
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.3, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}
