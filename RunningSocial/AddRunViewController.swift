//
//  AddRunViewController.swift
//  RunningSocial
//
//  Created by Lane Faison on 5/1/17.
//  Copyright © 2017 RunningSocial. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class AddRunViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var racePaceSwitch: UISwitch!
    @IBOutlet weak var addRunButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRunButton.isEnabled = true
        
        // set initial location to Denver
        
        let initialLocation = CLLocation(latitude: 39.7392, longitude: -104.9903)
        let regionRadius: CLLocationDistance = 50000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)

    }

    @IBAction func addRunTapped(_ sender: Any) {
        
        let newRun = FIRDatabase.database().reference().child("runs").childByAutoId()
        
        newRun.child("title").setValue(titleTextField.text)
        newRun.child("details").setValue(detailsTextField.text)
        newRun.child("distance").setValue(distanceTextField.text)
        newRun.child("date").setValue(datePicker.date)

        
    }
}
