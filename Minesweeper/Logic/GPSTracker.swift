//
//  GPSTracker.swift
//  Minesweeper
//
//  Created by Hadar Pur on 29/10/2018.
//  Copyright © 2018 Hadar Pur. All rights reserved.
//

import Foundation
import CoreLocation

class GPSTracker: CLLocationManager{
    var isGPSEnabled: Bool = false
    var isNetworkEnabled: Bool = false

    override init() {
        super.init()
        self.requestWhenInUseAuthorization()
        self.startUpdatingLocation()
    }
}
