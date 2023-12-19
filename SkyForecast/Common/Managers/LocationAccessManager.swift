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

protocol LocationAccessManagerDelegate: AnyObject {
    func didUpdateCityName(_ cityName: String)
}

final class LocationAccessManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationAccessManager()
    private let locationManager = CLLocationManager()
    public weak var delegate: LocationAccessManagerDelegate?
    
    public var userType: Constants.UserType = .anonymous {
        didSet {
            if userType == .authorized {
                locationManager.startUpdatingLocation()
            }
        }
    }
        
    // MARK: - Initialization
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
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
    
    // MARK: - Permission Handling
    public func makePermissionRequest(from viewController: Permissible, completion: @escaping (Bool) -> Void) {
        let config = LocationConfiguration(.whenInUse)
        Permission<Location>.prepare(for: viewController, with: config) { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.userType = .authorized
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
            geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "en")) { [weak self] (placemarks, error) in
                if let error = error {
                    print("Reverse geocoding error: \(error)")
                    return
                }
                
                if let placemark = placemarks?.first, let city = placemark.locality, let self = self {
                    DispatchQueue.main.async {
                        self.delegate?.didUpdateCityName(city)
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status.isAuthorized {
            manager.startUpdatingHeading()
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
