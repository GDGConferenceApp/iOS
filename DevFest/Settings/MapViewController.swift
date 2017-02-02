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
    @IBOutlet var openInMapsButton: MapOverlayButton!
    
    lazy var venueName: String = "University of St. Thomas"
    lazy var mapRegion: MKCoordinateRegion = {
        let swCorner = CLLocationCoordinate2D(latitude: 44.97395, longitude: -93.2783)
        let neCorner = CLLocationCoordinate2D(latitude: 44.974725, longitude: -93.27668)
        
        let center = CLLocationCoordinate2D(latitude: (swCorner.latitude + neCorner.latitude) / 2, longitude: (swCorner.longitude + neCorner.longitude) / 2)
        let span = MKCoordinateSpan(latitudeDelta: abs(neCorner.latitude - swCorner.latitude), longitudeDelta: abs(neCorner.longitude - swCorner.longitude))
        let region = MKCoordinateRegion(center: center, span: span)
        return region
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.setRegion(mapRegion, animated: false)
        
        openInMapsButton.action = { [unowned self] in
            let region = self.mapRegion
            
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
            ]
            
            let placemark = MKPlacemark(coordinate: region.center, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "\(self.venueName)"
            mapItem.openInMaps(launchOptions: options)
        }
    }

}
