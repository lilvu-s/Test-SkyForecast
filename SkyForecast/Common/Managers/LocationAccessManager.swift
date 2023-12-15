//
//  LocationAccessManager.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationAccessManager {
    static let shared = LocationAccessManager()
    
    //MARK: -

    var isAnonimysUser: Bool = false
    let defaultLat = 37.8267
    let defaultLon = -122.4233
    
    var currentLat: Double = 0
    var currentLon: Double = 0
    
    //MARK: -

    func isLocationAccessGranted() -> Bool {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            return true
        } else {
            return false
        }
    }
}
