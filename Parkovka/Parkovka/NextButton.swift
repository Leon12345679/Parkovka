//
//  NextButton.swift
//  Parkovka
//
//  Created by Leon Vladimirov on 3/22/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import UIKit

class NextButton: UIButton {
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
    }
}
