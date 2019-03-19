//
//  TypeOfViolationViewController.swift
//  Parkovka
//
//  Created by Leon Vladimirov on 1/22/19.
//  Copyright © 2019 Leon Vladimirov. All rights reserved.
//

import UIKit
import AudioToolbox

class ViolationTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let violationType: [String] = ["Несоблюдение требований дорожных знаков или разметки, запрещающих остановку или стоянку ТС.", "Остановка или стоянка ТС на пешеходном переходе и ближе 5 м перед ним, либо на тротуаре, если не разрешено знаками.", "Остановка или стоянка на остановке общественного транспорта или ближе 15 м от нее, (за искл. остановки для посадки или высадки пассажиров)", "Остановка или стоянка на трамвайных путях, а также далее первого ряда от края проезжей части ", "Остановка или стоянка, создающая препятствия для движения других ТС или в тоннеле", "Совершил другие нарушения правил остановки или стоянки ТС"]
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "cell"
    var SelectedSomething: Bool = false
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Along with auto layout, these are the keys for enabling variable cell height
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.violationType.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyCustomCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyCustomCell
        cell.myCellLabel.text = self.violationType[indexPath.row]
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Report.shared.typeOfViolation = self.violationType[indexPath.row]
        SelectedSomething = true
    }
    

    @IBAction func NextVC(_ sender: UIButton) {
        if SelectedSomething {
        self.performSegue(withIdentifier: "ToProtocol", sender: self)
        } else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}
