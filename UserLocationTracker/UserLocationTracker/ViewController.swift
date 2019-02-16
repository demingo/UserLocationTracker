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
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableSwitch()
        checkLocationServices() // Comprueba que Location está activado
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            disableSwitch()
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            enableSwitch()
        case .denied:
            disableSwitch()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            disableSwitch()
        case .authorizedWhenInUse:
            disableSwitch()
            break
        }
    }
    
    func enableSwitch() {
        switchLabel.isEnabled = true
        switchButton.isEnabled = true
        
        switchLabel.text = "Tracking"
    }
    
    func disableSwitch() {
        switchLabel.isEnabled = false
        switchButton.isEnabled = false
        
        switchLabel.text = "Location not enabled"
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }

}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
