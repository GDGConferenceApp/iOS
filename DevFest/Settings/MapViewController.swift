//
//  MapViewController.swift
//  DevFest
//
//  Created by Brendon Justin on 11/26/16.
//  Copyright © 2016 GDGConferenceApp. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var centerButton: MapOverlayButton!
    
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
        
        title = NSLocalizedString("Directions", comment: "Map view controller title")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Maps", comment: "Open venue address in Maps app"), style: .plain, target: self, action: #selector(openInMaps))
        
        mapView.setRegion(mapRegion, animated: false)
        
        CLGeocoder().geocodeAddressString("University of St. Thomas, 1000 Lasalle Ave, Minneapolis, MN 55403, United States") { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                // Fall back on manually placing an annotation using absolute coordinates.
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: 44.97430, longitude: -93.277595)
                annotation.title = self.venueName
                self.mapView.addAnnotation(annotation)
                return
            }
            
            let mkPlacemark = MKPlacemark(placemark: placemark)
            self.mapView.addAnnotation(mkPlacemark)
        }
        
        centerButton.action = { [unowned self] in
            self.mapView.setRegion(self.mapRegion, animated: true)
        }
    }

    @objc private func openInMaps() {
        let region = self.mapRegion
        
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
        ]
        
        let placemark = MKPlacemark(coordinate: region.center, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.venueName
        mapItem.openInMaps(launchOptions: options)
    }
}
