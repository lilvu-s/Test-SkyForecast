//
//  LocationAuthorizationViewController.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import UIKit
import PermissionsService

final class LocationAuthorizationViewController: UIViewController, Permissible {
    var authorizationHandler: ((Double, Double) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func authorizationTapped(_ sender: UIButton) {
        requestLocationAuthorization()
    }
    
    @IBAction func nonAuthorizedUse(_ sender: UIButton) {
        setLocationUserType(.anonymous)
        self.navigationController?.popViewController(animated: true)
        
        self.authorizationHandler?(Constants.Weather.defaultLat, Constants.Weather.defaultLon)
    }
    
    private func requestLocationAuthorization() {
        LocationAccessManager.shared.makePermissionRequest(from: self) { [weak self] granted in
            if granted {
                self?.setLocationUserType(.authorized)
                self?.navigationController?.popViewController(animated: true)
                
                let coordinates = LocationAccessManager.shared.getCurrentCoordinates()
                self?.authorizationHandler?(coordinates.lat, coordinates.lon)
            }
        }
    }
    
    private func setLocationUserType(_ userType: Constants.UserType) {
        LocationAccessManager.shared.userType = userType
    }
}


