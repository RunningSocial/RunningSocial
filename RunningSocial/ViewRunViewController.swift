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
    @IBOutlet weak var runOwner: UILabel!
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
        runOwner.text = run.owner
        runDetails.text = run.details
        runDistance.text = run.distance
        runDifficulty.text = run.difficulty
        latitudeLabel.text = run.latitude
        longitudeLabel.text = run.longitude
        
        let latitudeDouble: CLLocationDegrees = (NumberFormatter().number(from: run.latitude)?.doubleValue)!
        let longitudeDouble: CLLocationDegrees = (NumberFormatter().number(from: run.longitude)?.doubleValue)!
        let singleRunLocation = CLLocationCoordinate2D(latitude: latitudeDouble, longitude: longitudeDouble)
        let singleRunAnnotation = MKPointAnnotation()
        singleRunAnnotation.coordinate = singleRunLocation
        singleRunAnnotation.title = run.title
        self.mapView.addAnnotation(singleRunAnnotation)
        
        //TEST TEST
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeDouble, longitudeDouble)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print("There is no address for this location")
            } else {
                if let place = placemark?[0]
                {
                    if let checker = place.subThoroughfare {
                        print("//////////////////")
                        print("\(place.subThoroughfare!) \n \(place.Thoroughfare!)")
                    }
                }
            }
        }
        
        //^^TEST TEST

        // set location to run's location
        let initialLocation = CLLocation(latitude: latitudeDouble, longitude: longitudeDouble)
        let regionRadius: CLLocationDistance = 500
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
        
        // Convert UTC time to current timezone
        print(run.date)
        let dateString = run.date
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+6:00")
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let newDate = dateFormatter.date(from: dateString)
        print(newDate!)
        // Convert current time to a String

        let dateFormatter2 = DateFormatter()
        dateFormatter2.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter2.dateFormat = "MM-dd-yyyy h:mm a" // works!
        dateFormatter2.dateFormat = "E MMM d, h:mm a" // works!
        let dateAsString = dateFormatter2.string(from: newDate!)
        print("dateAsString: \(dateAsString)")
        runDateTime.text = dateAsString
    }
}
