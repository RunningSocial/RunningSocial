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

class AddRunViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    var pace = [String]()
    var length = [String]()
    
    var dateAndTimePicker = UIPickerView()
    var lengthPicker = UIPickerView()
    var difficultyPicker = UIPickerView()
    
    var stringifiedLatitude : String = ""
    var stringifiedLongitude : String = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var difficultyTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var addRunButton: UIButton!
    
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("INITIAL DATE: \(Date())")
        addRunButton.layer.cornerRadius = 20
        
        pace = ["Beginner", "Intermediate", "Advanced", "Expert"]
        length = ["1 mile","2 miles","3 miles","5K","4 miles","5 miles","6 miles","10K","7 miles","8 miles","9 miles","10 miles","11 miles","12 miles","13 miles","Half Marathon"]
        
        dateAndTime.isHidden = true
        errorLabel.isHidden = true
        longitudeLabel.isHidden = true
        latitudeLabel.isHidden = true
        
        dateAndTimePicker.delegate = self
        dateAndTimePicker.dataSource = self
        datePicker.minuteInterval = 15
        datePicker.timeZone = TimeZone.current // Returns America/Denver (current)
        lengthPicker.delegate = self
        lengthPicker.dataSource = self
        lengthPicker.tag = 0
        distanceTextField.inputView = lengthPicker
        
        difficultyPicker.delegate = self
        difficultyPicker.dataSource = self
        difficultyPicker.tag = 1
        difficultyTextField.inputView = difficultyPicker
        
        // start updating user location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
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
        // so that user can tweak a bad press
        print(annotation.coordinate)
        locationManager.stopUpdatingLocation()
        print("Latitude is \(annotation.coordinate.latitude) and Longitude is \(annotation.coordinate.longitude)")
        // convert double to string
        stringifiedLatitude = String(format:"%.4f", annotation.coordinate.latitude)
        stringifiedLongitude = String(format:"%.4f", annotation.coordinate.longitude)
        print("As strings, Latitude = \(stringifiedLatitude) and Longitude = \(stringifiedLongitude)")
        // convert back to a Double
        let doubleLatitude = Double(stringifiedLatitude)!
        let doubleLongitude = Double(stringifiedLongitude)!
        print("Back to a Double: Lat = \(String(describing: doubleLatitude)) and Long = \(String(describing: doubleLongitude))")
        print("##########")
        longitudeLabel.text = stringifiedLongitude
        latitudeLabel.text = stringifiedLatitude
    }
    
    // centers map on user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let userLat = userLocation.coordinate.latitude
        let userLong = userLocation.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.25
        let longDelta: CLLocationDegrees = 0.25
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let location = CLLocationCoordinate2DMake(userLat, userLong)
        let region = MKCoordinateRegionMake(location, span)
        self.mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.title = "Your Location"
        annotation.coordinate = location
        self.mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()
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
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Converts local time to UTC time
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        dateAndTime.text = dateFormatter.string(from: date as Date)
        // This stores the date as a string in the hidden dateAndTime label
    }
    
    @IBAction func addRunTapped(_ sender: Any) {
        // This sequence checks that the user has filled out each field and will throw an error if otherwise. You do not need to worry about time zones here because datePicker.date and Date() are in the same time zone.
        if (longitudeLabel.text=="Longitude") || (latitudeLabel.text=="Latitude") {
            errorLabel.text = "*Please choose a starting point*"
            errorLabel.isHidden = false
        } else if (dateAndTime.text=="Label") || (datePicker.date < Date()) {
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
            let newRun = ["owner": FIRAuth.auth()?.currentUser!.email!, "title": self.titleTextField.text, "details": self.detailsTextField.text, "distance": self.distanceTextField.text, "difficulty": self.difficultyTextField.text, "date": self.dateAndTime.text, "latitude": latitudeLabel.text, "longitude": longitudeLabel.text]
            FIRDatabase.database().reference().child("runs").childByAutoId().setValue(newRun)
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
}

