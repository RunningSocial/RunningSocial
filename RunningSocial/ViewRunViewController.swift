//
//  ViewRunViewController.swift
//  RunningSocial
//
//  Created by Lane Faison on 5/2/17.
//  Copyright © 2017 RunningSocial. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewRunViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var runTitle: UILabel!
    @IBOutlet weak var runDetails: UILabel!
    @IBOutlet weak var runDistance: UILabel!
    @IBOutlet weak var runDifficulty: UILabel!
    @IBOutlet weak var runDateTime: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    var run = Run()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        latitudeLabel.isHidden = true
        longitudeLabel.isHidden = true
        
        runTitle.text = run.title
        runDetails.text = run.details
        runDistance.text = run.distance
        runDifficulty.text = run.difficulty
        runDateTime.text = run.date
        latitudeLabel.text = run.latitude
        longitudeLabel.text = run.longitude
        
        let latitudeDouble: CLLocationDegrees = (NumberFormatter().number(from: run.latitude)?.doubleValue)!
        let longitudeDouble: CLLocationDegrees = (NumberFormatter().number(from: run.longitude)?.doubleValue)!
        // start annotation code
        let singleRunLocation = CLLocationCoordinate2D(latitude: latitudeDouble, longitude: longitudeDouble)
        let singleRunAnnotation = MKPointAnnotation()
        singleRunAnnotation.coordinate = singleRunLocation
        singleRunAnnotation.title = run.title
        self.mapView.addAnnotation(singleRunAnnotation)
        

        // set location to run's location
        let initialLocation = CLLocation(latitude: latitudeDouble, longitude: longitudeDouble)
        let regionRadius: CLLocationDistance = 500
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
    }
}
