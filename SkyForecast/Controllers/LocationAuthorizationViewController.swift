//
//  LocationAuthorizationViewController.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import Foundation
import UIKit
import PermissionsService
import CoreLocation

class LocationAuthorizationViewController: UIViewController {
    let identifier = "LocationAuthorizationViewController"
    
    static let locationManager = CLLocationManager()

    //MARK: - Actions
    @IBAction func authorizationTapped(_ sender: UIButton) {
        LocationAccessManager.shared.isAnonimysUser = false
        makePermissionRequest()
    }
    
    @IBAction func nonAuthorizedUse(_ sender: UIButton) {
        LocationAccessManager.shared.isAnonimysUser = true
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Private
    private func makePermissionRequest() {
        
        let config = LocationConfiguration(.whenInUse)
        Permission<Location>.prepare(for: self, with: config) { (granted) in
            if granted && (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways)  {
                print("All is good. Location access granted.")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else if granted {
                print("Location__ authorization problem!")
                /// maybe needs something?
            }
        }
    }

    
    @objc func locationManager(_ manager: CLLocationManager,didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
    }
    
}

extension LocationAuthorizationViewController: CLLocationManagerDelegate, Permissible {
    //no op needed
}
