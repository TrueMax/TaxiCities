//
//  CityAnnotation.swift
//  TaxiCities
//
//  Created by Maxim on 13.05.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import Foundation
import MapKit

class CityAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.title = title
        self.coordinate = coordinate
    }
    
}
