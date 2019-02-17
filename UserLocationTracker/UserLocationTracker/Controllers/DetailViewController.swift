//
//  DetailViewController.swift
//  UserLocationTracker
//
//  Created by Antonio De Mingo Navarro on 17/02/2019.
//  Copyright © 2019 Antonio De Mingo Navarro. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    
    var selectedJourney = [CLLocation]()
    var coordinates = [CLLocationCoordinate2D]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedJourney.forEach { location in
            coordinates.append(location.coordinate)
        }
        
        setupLabels()
        addJourneyOverlay()
    }
    
    //MARK: - Methods
    func setupLabels() {
        var journeyDate = " "
        var journeyTime = " "
        var avgSpeedRounded = " "
        var harvesineDistance = " "
        var altitude = " "
        
        if (selectedJourney.first?.timestamp != nil) && (selectedJourney.last?.timestamp != nil) {
            let duration = DateInterval.init(start: selectedJourney.first!.timestamp, end: selectedJourney.last!.timestamp)
            let formatter = DateIntervalFormatter()
            let durationString = formatter.string(from: duration)
            journeyDate = durationString!.components(separatedBy: ",")[0]
            journeyTime = durationString!.components(separatedBy: ",")[1]
            journeyTime.removeFirst()
            
            let filteredSpeed = selectedJourney.filter { $0.speed > 0 }
            let totalSpeed = filteredSpeed.reduce(0) { (result, next) -> Double in
                return result + next.speed
            }
            let avgSpeed = (totalSpeed * 3.6) / Double(filteredSpeed.count)
            avgSpeedRounded = String(avgSpeed.rounded())
            harvesineDistance = String(selectedJourney.first!.distance(from: selectedJourney.last!).rounded())
            altitude = String((selectedJourney.last!.altitude - selectedJourney.first!.altitude).rounded())
        }
        dateLabel.text = journeyDate
        timeLabel.text = "time: " + journeyTime
        distanceLabel.text = "distance: " + harvesineDistance + " meters"
        speedLabel.text = "speed: " + avgSpeedRounded + " km/h"
        altitudeLabel.text = "altitude: " + altitude + " meters"
    }
    
    func addJourneyOverlay() {
        if let location = selectedJourney.first?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlays([polyline])
    }

}

//MARK: - Map View
extension DetailViewController: MKMapViewDelegate {
    
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
