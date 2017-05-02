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
import CoreLocation

class AddRunViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, MKMapViewDelegate {
    
    var pace = ["Slow", "Intermediate", "Advanced"]
    var picker = UIPickerView()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var difficultyTextField: UITextField!
    @IBOutlet weak var addRunButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRunButton.isEnabled = false
        
        picker.delegate = self
        picker.dataSource = self
        difficultyTextField.inputView = picker
        
        // set initial location to Denver
        let initialLocation = CLLocation(latitude: 39.7392, longitude: -104.9903)
        let regionRadius: CLLocationDistance = 50000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
        
        // UI LongPress Recognizer to drop a pin
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(AddRunViewController.longpress(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 1.5
        mapView.addGestureRecognizer(uilpgr)
        
    }
    // drops pin after one second long press
    func longpress(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        let annotation  = MKPointAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = "Starting Point"
        //annotation.subtitle = "New starting point"
        mapView.addAnnotation(annotation)
        // currently allows more than one long press
        // and generates more than one lat and long
        print(annotation.coordinate.latitude, annotation.coordinate.longitude)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pace.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pace[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        difficultyTextField.text = pace[row]
        self.view.endEditing(false)
    }
    
    @IBAction func titleTextChanged(_ sender: Any) {
        addRunButton.isEnabled = true
    }
    
    @IBAction func addRunTapped(_ sender: Any) {
        print("DATEPICKER")
        print(datePicker.date)
        print("#########")
        print("RUNDATE")
        print("########")
        
        let newRun = ["owner":FIRAuth.auth()?.currentUser!.email!,"title":titleTextField.text,"details":detailsTextField.text,"distance":distanceTextField.text,"difficulty":difficultyTextField.text]
        
        FIRDatabase.database().reference().child("runs").childByAutoId().setValue(newRun)
        
        navigationController!.popToRootViewController(animated: true)
        
    }
}
