//
//  LocationManager.swift
//  Reminders
//
//  Created by Kyrill Cousson on 15/02/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
    func didUpdateLocation(location:CLLocation)
}

final class LocationManager : NSObject, CLLocationManagerDelegate {
    
    static let sharedLocationManager = LocationManager()
    var userLocation: CLLocation!
    var isUpdatingLocation : Bool = false
    var delegate :LocationManagerDelegate?
    
    lazy var locationManager : CLLocationManager = {()->CLLocationManager in
        let lm = CLLocationManager()
        lm.delegate = self
        return lm
    }()
    
    private override init() {
        super.init()
    }
    
    func startUpdatingLocation(){
        if (isUpdatingLocation == false){
            isUpdatingLocation = true;
            if (locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))){
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.startUpdatingLocation()
            print("LocationManager - Did start updating location")
        }
    }
    
    func stopUpdatingLocation(){
        if (isUpdatingLocation){
            locationManager.stopUpdatingLocation()
            isUpdatingLocation = false;
            print("LocationManager - Did stop updating location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("LocationManager - Did update locations:")
        if let userLoc = locations.last {
            delegate?.didUpdateLocation(location: userLoc)
        }
    }
    
}
