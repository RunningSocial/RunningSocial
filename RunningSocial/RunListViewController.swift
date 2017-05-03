//
//  RunListViewController.swift
//  RunningSocial
//
//  Created by Lane Faison on 5/1/17.
//  Copyright © 2017 RunningSocial. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class RunListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var upcomingMapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var runs : [Run] = []
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.reloadData()
        
        let currentDate = Date()
        
        FIRDatabase.database().reference().child("runs").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            
            let run = Run()
            run.date = (snapshot.value as! NSDictionary)["date"] as! String
            run.owner = (snapshot.value as! NSDictionary)["owner"] as! String
            run.title = (snapshot.value as! NSDictionary)["title"] as! String
            run.details = (snapshot.value as! NSDictionary)["details"] as! String
            run.distance = (snapshot.value as! NSDictionary)["distance"] as! String
            run.difficulty = (snapshot.value as! NSDictionary)["difficulty"] as! String
            
            // String to NSDate
            let dateString = run.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            dateFormatter.timeZone = TimeZone(abbreviation: "MST-7:00")
            let newDate = dateFormatter.date(from: dateString)
            
//            if (newDate! > currentDate) {
                // Appends run if it is in the future so it can be viewed in the table.
                print("Run appended")
                self.runs.append(run)
                self.tableView.reloadData()
//            } else {
//                print("This date has passed")
//                print("Run date was in the past and will be deleted from the DB")
//                // NEED function to remove data
//                self.tableView.reloadData()
//            }
        })
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        print("started updating location")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let run = runs[indexPath.row]
        cell.textLabel?.text = run.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let run = runs[indexPath.row]
        performSegue(withIdentifier: "viewrunsegue", sender: run)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewrunsegue" {
            let nextVC = segue.destination as! ViewRunViewController
            nextVC.run = sender as! Run
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        print(userLocation)
        let userLat = userLocation.coordinate.latitude
        let userLong = userLocation.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.25
        let longDelta: CLLocationDegrees = 0.25
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let location = CLLocationCoordinate2DMake(userLat, userLong)
        let region = MKCoordinateRegionMake(location, span)
        self.upcomingMapView.setRegion(region, animated: true)
        
        // add a pin to the centerpoint of the map
        let annotation = MKPointAnnotation()
        annotation.title = "Your Location"
        //annotation.subtitle = "Starting point"
        annotation.coordinate = location
        upcomingMapView.addAnnotation(annotation)
        
        // problems: continually updating, provides too many data points
        
        
        
    }
    
    // LOGOUT FUNCTION
    @IBAction func logoutTapped(_ sender: Any) {
        print("Sign out initiated")
        dismiss(animated: true, completion: nil)
    }
}
