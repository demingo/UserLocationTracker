//
//  JourneysViewController.swift
//  UserLocationTracker
//
//  Created by Antonio De Mingo Navarro on 16/02/2019.
//  Copyright © 2019 Antonio De Mingo Navarro. All rights reserved.
//

import UIKit
import CoreLocation

class JourneysViewController: UIViewController {
    
    var myJourneys = [[CLLocation]]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension JourneysViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myJourneys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Journey \(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: myJourneys[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? DetailViewController {
            destinationViewController.selectedJourney = sender as! [CLLocation]
        }
    }
    
}
