//
//  MapViewController.swift
//  TaxiCities
//
//  Created by Maxim on 13.05.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goBackToCities(sender: UIBarButtonItem){
        dismissViewControllerAnimated(true, completion: nil)
    }
}
