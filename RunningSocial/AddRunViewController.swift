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

class AddRunViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
        
        picker.delegate = self
        picker.dataSource = self
        
        difficultyTextField.inputView = picker
        
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
    
    

    @IBAction func addRunTapped(_ sender: Any) {
        
        let newRun = FIRDatabase.database().reference().child("runs").childByAutoId()
        
        newRun.child("owner").setValue(FIRAuth.auth()?.currentUser?.email!)
        newRun.child("title").setValue(titleTextField.text!)
        
        navigationController!.popToRootViewController(animated: true)
    }
}
