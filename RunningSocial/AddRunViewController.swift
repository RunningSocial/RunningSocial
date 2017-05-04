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

class AddRunViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, MKMapViewDelegate, UITextFieldDelegate {

    var pace = [String]()
    var length = [String]()
    
    var dateAndTimePicker = UIPickerView()
    var lengthPicker = UIPickerView()
    var difficultyPicker = UIPickerView()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var difficultyTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var addRunButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pace = ["Beginner", "Intermediate", "Advanced", "Expert"]
        length = ["1 mile","2 miles","3 miles","5K","4 miles","5 miles","6 miles","10K","7 miles","8 miles","9 miles","10 miles","11 miles","12 miles","13 miles","Half Marathon", "14+ miles"]
        
        dateAndTime.isHidden = true
        errorLabel.isHidden = true
        
        dateAndTimePicker.delegate = self
        dateAndTimePicker.dataSource = self
        datePicker.minuteInterval = 15        
        
        lengthPicker.delegate = self
        lengthPicker.dataSource = self
        lengthPicker.tag = 0
        distanceTextField.inputView = lengthPicker
        
        difficultyPicker.delegate = self
        difficultyPicker.dataSource = self
        difficultyPicker.tag = 1
        difficultyTextField.inputView = difficultyPicker
        
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
        uilpgr.minimumPressDuration = 1
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
        print(annotation.coordinate)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return pace.count
        } else {
            return length.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return pace[row]
        } else {
            return length[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            difficultyTextField.text = pace[row]
            self.view.endEditing(false)
        } else {
            distanceTextField.text = length[row]
            self.view.endEditing(false)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0,y:250), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
                scrollView.setContentOffset(CGPoint(x:0,y:-50), animated: true)
    }
    
    @IBAction func timeChanged(_ sender: Any) {
        //NSDate to String
        let date = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"
        dateAndTime.text = dateFormatter.string(from: date as Date)
        // This stores the date as a string in the hidden dateAndTime label
    }
    
    @IBAction func addRunTapped(_ sender: Any) {
        // This sequence checks that the user has filled out each field and will throw an error if otherwise. You do not need to worry about time zones here because datePicker.date and Date() are in the same time zone.
        
        if (dateAndTime.text=="Label") || (datePicker.date < Date()) {
            errorLabel.text = "*Please pick a time in the future*"
            errorLabel.isHidden = false
        } else if (titleTextField.text=="") {
            errorLabel.text = "*Please give your run a title*"
            errorLabel.isHidden = false
        } else if (detailsTextField.text=="") {
            errorLabel.text = "*Please add some details*"
            errorLabel.isHidden = false
        } else if (distanceTextField.text=="") {
            errorLabel.text = "*Please pick a distance*"
            errorLabel.isHidden = false
        } else if (difficultyTextField.text=="") {
            errorLabel.text = "*Please pick a difficulty*"
            errorLabel.isHidden = false
        } else {
            // User has completed all fields so the run is added to the db.
            errorLabel.isHidden = true
            let newRun = ["owner": FIRAuth.auth()?.currentUser!.email!, "title": self.titleTextField.text, "details": self.detailsTextField.text, "distance": self.distanceTextField.text, "difficulty": self.difficultyTextField.text, "date": self.dateAndTime.text]
            FIRDatabase.database().reference().child("runs").childByAutoId().setValue(newRun)
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    

}

