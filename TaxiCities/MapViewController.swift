//
//  MapViewController.swift
//  TaxiCities
//
//  Created by Maxim on 13.05.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    lazy var cityName = ""
    lazy var cityLatitude: CLLocationDegrees = 0.0
    lazy var cityLongitude: CLLocationDegrees = 0.0
    lazy var regionRadius: Double = 15000
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let initialLocation = CLLocation(latitude: cityLatitude, longitude: cityLongitude)
        centerMapOnLocation(initialLocation)
        
        let coordinate = CLLocationCoordinate2DMake(cityLatitude, cityLongitude)
        let annotation = CityAnnotation(coordinate: coordinate, title: cityName)
        
        mapView.addAnnotation(annotation)
    }
    
    
    func centerMapOnLocation (location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    
    
    @IBAction func goBackToCities(sender: UIBarButtonItem){
        dismissViewControllerAnimated(true, completion: nil)
    }
}
