//
//  LocationSelectionView.swift
//  Reminders
//
//  Created by Kyrill Cousson on 12/02/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LocationSelectionView : UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var circleView: CircleView!

    // set a default initial location
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius: CLLocationDistance = 200
    let selectionCircleRadiusToMapWidthMultiplier: Double = 4
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LocationSelectionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        circleView.setColor(color: UIColor.red)
        circleView.alpha = 0.4
        circleView.isUserInteractionEnabled = false
        
        guard let userCoordinate = mapView.userLocation.location else {
            centerMapOnLocation(location: initialLocation)
            return
        }
        centerMapOnLocation(location: userCoordinate)
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius*2, longitudinalMeters: regionRadius*2)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func centerMapOnSavedLocation(location: Location){
        print("loaded radius: \(location.radius)")
        print("displayed longitude size: \(location.radius*selectionCircleRadiusToMapWidthMultiplier)")

        let coordinateRegion = MKCoordinateRegion(center: CLLocation.init(latitude: location.latitude, longitude: location.longitude).coordinate,
                                                  latitudinalMeters: location.radius*selectionCircleRadiusToMapWidthMultiplier,
                                                  longitudinalMeters: location.radius*selectionCircleRadiusToMapWidthMultiplier)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func selectionRadius() -> Double {
        // The selection circle size is relative to the region longitude.
        // Selection circle diameter = region longitude / 2
        let radius = self.mapView.region.sizeInMeters().longitudeDistance / selectionCircleRadiusToMapWidthMultiplier
        print("displayed longitude size: \(self.mapView.region.sizeInMeters().longitudeDistance)")
        print("will save radius: \(radius)")
        return radius
    }
    
    func selectedLocation() -> (latitude: Double, longitude: Double, radius: Double) {
        return (latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude, radius: selectionRadius())
    }
    
}
