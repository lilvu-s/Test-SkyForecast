//
//  DailyWeatherTableViewContoroller.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import UIKit
import CoreLocation

final class DailyWeatherTableViewController: UITableViewController {
    private let locationManager = LocationAccessManager.shared
    
    var weather: WeekWeather? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var weatherData: [DailyWeather] {
        return weather?.days ?? []
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        requestLocationAccess()
    }
    
    // MARK: - Fetch data
    private func requestLocationAccess() {
        if locationManager.userType == .anonymous {
            title = "\(Constants.Weather.defaultLat), \(Constants.Weather.defaultLon)"
            performSegue(withIdentifier: Constants.Segue.presentAuthorization, sender: nil)
        }
    }
    
    private func updateWeatherData(withLat lat: Double, lon: Double) {
        fetchWeatherData(for: lat, lon: lon)
    }
    
    private func fetchWeatherData(for lat: Double, lon: Double) {
        NetworkManager().dailyWeather(for: lat, lon: lon) { [weak self] (isSuccess, error, object) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if isSuccess {
                    self.weather = object
                } else if let error = error {
                    self.weather = nil
                    self.showError(error.descriptor)
                } else {
                    self.weather = nil
                }
            }
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Weather.weatherCellIdentifier, for: indexPath) as? DailyWeatherTableViewCell else {
            return UITableViewCell()
        }
        let weatherEntry = weatherData[indexPath.row]
        cell.setup(with: weatherEntry)
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.presentAuthorization,
           let authorizationViewController = segue.destination as? LocationAuthorizationViewController {
            authorizationViewController.authorizationHandler = { [weak self] lat, lon in
                self?.updateWeatherData(withLat: lat, lon: lon)
            }
        }
        else if segue.identifier == Constants.Segue.showDetailedWeather,
                let vc = segue.destination as? DetailedWeatherTableViewController,
                let path = tableView.indexPathForSelectedRow {
            vc.model = weatherData[path.row]
        }
    }
}

// MARK: - LocationAccessManager Delegate
extension DailyWeatherTableViewController: LocationAccessManagerDelegate {
    func didUpdateCityName(_ cityName: String) {
        title = cityName
    }
}
