//
//  DetailedWeatherTableViewController.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import Foundation
import UIKit

final class DetailedWeatherTableViewController: UITableViewController {
    //MARK: - Outlets
    @IBOutlet weak var highestTemperatureLabel: UILabel!
    @IBOutlet weak var lowestTemperatureLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    
    var model: DailyWeather?
    var isLowVisibility: Bool = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateWeatherDisplay()
    }
    
    // MARK: - Setup
    private func updateWeatherDisplay() {
        guard let weather = model else { return }
        
        setLabelValues(with: weather)
        isLowVisibility = weather.visibility < 10
        
        updateTableHeader(for: weather.visibility)
        tableView.reloadData()
    }
    
    private func setLabelValues(with weather: DailyWeather) {
        highestTemperatureLabel.text = "The highest temperature is \(weather.tempmax)"
        lowestTemperatureLabel.text = "The lowest temperature is \(weather.tempmin)"
        windSpeedLabel.text = "Wind speed is around \(weather.windspeed)"
    }
    
    private func updateTableHeader(for visibility: Double) {
        if isLowVisibility {
            visibilityLabel.textColor = .red
            visibilityLabel.font = .systemFont(ofSize: 20, weight: .semibold)
            visibilityLabel.text = "⚠️ Visibility \(visibility)"
            tableView.tableHeaderView = visibilityLabel
            
            visibilityLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                visibilityLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 10),
                visibilityLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 16),
                visibilityLabel.widthAnchor.constraint(equalTo: tableView.widthAnchor)
            ])
        } else {
            visibilityLabel.text = "Visibility \(visibility)"
            tableView.tableHeaderView = nil
        }
    }
    
    //MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLowVisibility ? 3 : 4
    }
}

