//
//  MapViewController.swift
//  DevFest
//
//  Created by Brendon Justin on 11/26/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swCorner = CLLocationCoordinate2D(latitude: 44.97395, longitude: -93.2783)
        let neCorner = CLLocationCoordinate2D(latitude: 44.974725, longitude: -93.27668)
        
        let center = CLLocationCoordinate2D(latitude: (swCorner.latitude + neCorner.latitude) / 2, longitude: (swCorner.longitude + neCorner.longitude) / 2)
        let span = MKCoordinateSpan(latitudeDelta: abs(neCorner.latitude - swCorner.latitude), longitudeDelta: abs(neCorner.longitude - swCorner.longitude))
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
    }

}
