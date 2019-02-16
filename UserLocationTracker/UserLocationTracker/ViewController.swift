//
//  ViewController.swift
//  UserLocationTracker
//
//  Created by Antonio De Mingo Navarro on 15/02/2019.
//  Copyright © 2019 Antonio De Mingo Navarro. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func checkLocationServices() { // Comprueba que Location está activado en el teléfono
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
        } else {
            // Dar indicación al usuario
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}
