//
//  LocationEditionViewController.swift
//  Reminders
//
//  Created by Kyrill Cousson on 28/01/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class LocationEditionViewController: UIViewController, UITextFieldDelegate, LocationManagerDelegate {
    
    @IBOutlet weak var locationNameField: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var locationSelectionView: LocationSelectionView!
    
    var context: NSManagedObjectContext?
    let locationManager = LocationManager.sharedLocationManager

    var location : Location?
    
    func setLocation(location:Location) {
        self.location = location
    }
    
    func setupNewLocation(){
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: self.context!)
        self.location = NSManagedObject(entity: entity!, insertInto: context) as? Location
        self.location!.id = UUID()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        if (self.location == nil){
            setupNewLocation()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        else {
            locationNameField.text = location?.name
            locationSelectionView.centerMapOnSavedLocation(location: location!)
        }
        
        self.saveBtn.isEnabled = !(location?.name.isEmptyOrNil())!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationNameField.delegate = self
        locationNameField.addTarget(self, action: #selector(textFieldValueDidChange(textField:)), for: .editingChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldValueDidChange(textField: UITextField) {
        location?.name = textField.text!
        self.saveBtn.isEnabled = !(location?.name.isEmptyOrNil())!
    }
    
    func didUpdateLocation(location: CLLocation) {
        locationSelectionView.centerMapOnLocation(location: location)
        
        if (location.verticalAccuracy < 100 && location.horizontalAccuracy < 100){
            locationManager.stopUpdatingLocation()
        }
    }
    
    // MARK: - User Actions

    @IBAction func saveAct(_ sender: Any) {
        let mapSelection = locationSelectionView.selectedLocation()
        location?.latitude = mapSelection.latitude
        location?.longitude = mapSelection.longitude
        location?.radius = mapSelection.radius
        
        saveData(onContext:self.context)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAct(_ sender: Any) {
        discardChanges(onContext: self.context)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
