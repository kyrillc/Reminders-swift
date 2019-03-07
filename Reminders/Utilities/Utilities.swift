//
//  Utilities.swift
//  Reminders
//
//  Created by Kyrill Cousson on 29/01/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import Foundation
import MapKit

extension Optional where Wrapped == String {
    func isEmptyOrNil() -> Bool{
        if let string = self, string.isEmpty == false {
            return false
        }
        return true
    }
}

extension MKCoordinateRegion{
    public func sizeInMeters() -> (latitudeDistance: Double, longitudeDistance: Double){
        
        // North - center longitude:
        let loc1 = CLLocation(latitude: self.center.latitude - self.span.latitudeDelta * 0.5, longitude: self.center.longitude)
        // South - center longitude:
        let loc2 = CLLocation(latitude: self.center.latitude + self.span.latitudeDelta * 0.5, longitude: self.center.longitude)
        // West - center latitude:
        let loc3 = CLLocation(latitude: self.center.latitude, longitude: self.center.longitude - self.span.longitudeDelta * 0.5)
        // East - center latitude:
        let loc4 = CLLocation(latitude: self.center.latitude, longitude: self.center.longitude + self.span.longitudeDelta * 0.5)
        
        // North-South distance:
        let latitudeDistance = loc1.distance(from: loc2) as Double
        // West-East distance:
        let longitudeDistance = loc3.distance(from: loc4) as Double
        
        return (latitudeDistance: latitudeDistance, longitudeDistance: longitudeDistance)
    }
}

