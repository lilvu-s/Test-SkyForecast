//
//  LocationAccessManager.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import UIKit
import CoreLocation
import PermissionsService

final class LocationAccessManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationAccessManager()
    private let locationManager = CLLocationManager()
    
    public enum UserType {
        case anonymous
        case authorized
    }
    
    public var userType: UserType = .anonymous {
        didSet {
            if userType == .authorized {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    public var locationUpdateHandler: ((String) -> Void)?
    
    // MARK: - Initialization
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        determineUserType()
    }
    
    // MARK: - User Type Handling
    private func determineUserType() {
        userType = CLLocationManager.authorizationStatus().isAuthorized ? .authorized : .anonymous
    }
    
    // MARK: - Location Services
    public func getCurrentCoordinates() -> (lat: Double, lon: Double) {
        guard let location = locationManager.location else {
            return (Constants.Weather.defaultLat, Constants.Weather.defaultLon)
        }
        return (location.coordinate.latitude, location.coordinate.longitude)
    }
    
    public func updateLocation() {
        if userType == .authorized {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Permission Handling
    public func makePermissionRequest(from viewController: Permissible, completion: @escaping (Bool) -> Void) {
        let config = LocationConfiguration(.whenInUse)
        Permission<Location>.prepare(for: viewController, with: config) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.userType = .authorized
                    completion(true)
                } else {
                    completion(false)
                    print("Location permission denied")
                }
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "en")) { (placemarks, error) in
                if let error = error {
                    print("Reverse geocoding error: \(error)")
                    return
                }
                
                if let placemark = placemarks?.first, let city = placemark.locality {
                    DispatchQueue.main.async {
                        self.locationUpdateHandler?(city)
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status.isAuthorized {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with error: \(error.localizedDescription)")
    }
}

// MARK: - CLAuthorizationStatus Extension
private extension CLAuthorizationStatus {
    var isAuthorized: Bool {
        return self == .authorizedWhenInUse || self == .authorizedAlways
    }
}
