//
//  ReportClass.swift
//  Parkovka
//
//  Created by Leon Vladimirov on 3/17/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import UIKit

class Report {
    static let shared = Report()
    var carModel: String
    var placeOfReport: String
    var carNumber: String
    var carNumberCode: String
    var typeOfViolation: String
    var images = [UIImage]()
    
    init() {
        self.carModel = ""
        self.placeOfReport = ""
        self.carNumber = ""
        self.carNumberCode = ""
        self.typeOfViolation = ""
        self.images = [UIImage]()
    }
}
