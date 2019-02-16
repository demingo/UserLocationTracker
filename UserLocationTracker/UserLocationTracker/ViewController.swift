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
    var coordinates = [CLLocationCoordinate2D]()
    var locations = [CLLocation]()
    var myJourneys = [[CLLocation]]()
    
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
            // Notificar al usuario de que Locactions está desactivado en el teléfono
            disableSwitch()
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            mapView.showsUserLocation = true
            mapView.setUserTrackingMode(.follow, animated: true)
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
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        if !sender.isOn {
            mapView.removeOverlays(mapView.overlays)
            coordinates.removeAll()
            myJourneys.append(locations)
            locations.removeAll()
            locationManager.pausesLocationUpdatesAutomatically = true
            locationManager.stopUpdatingLocation()
        } else {
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    

}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
            let polyline = overlay as? MKPolyline
            let polylineRenderer = MKPolylineRenderer(polyline: polyline!)
            
            polylineRenderer.strokeColor = UIColor.red
            polylineRenderer.lineWidth = 3.0
            
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let coordinate = locations.last?.coordinate else { return }
        
        if switchButton.isOn {
            let location = locations.last
            self.locations.append(location!)
            mapView.setUserTrackingMode(.follow, animated: true)
            coordinates.append(coordinate)
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlays([polyline])
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
