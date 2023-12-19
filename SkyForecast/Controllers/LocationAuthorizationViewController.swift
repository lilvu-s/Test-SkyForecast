//
//  LocationAuthorizationViewController.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import UIKit
import PermissionsService

class LocationAuthorizationViewController: UIViewController, Permissible {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func authorizationTapped(_ sender: UIButton) {
        LocationAccessManager.shared.makePermissionRequest(from: self) { [weak self] granted in
            if granted {
                LocationAccessManager.shared.userType = .authorized
                
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func nonAuthorizedUse(_ sender: UIButton) {
        LocationAccessManager.shared.userType = .anonymous
        self.navigationController?.popViewController(animated: true)
    }
}


