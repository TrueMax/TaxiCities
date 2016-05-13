//
//  CityCell.swift
//  TaxiCities
//
//  Created by Maxim on 12.05.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCity(city: City) {
        label.text = city.name
    }
}
