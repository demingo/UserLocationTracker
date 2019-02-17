//
//  DetailViewController.swift
//  UserLocationTracker
//
//  Created by Antonio De Mingo Navarro on 17/02/2019.
//  Copyright © 2019 Antonio De Mingo Navarro. All rights reserved.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailLabel: UILabel!
    var selectedJourney = [CLLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print(selectedJourney.count)
    }
    

}
