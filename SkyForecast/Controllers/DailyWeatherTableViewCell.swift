//
//  DailyWeatherTableViewCell.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import Foundation
import UIKit

class DailyWeatherTableViewCell: UITableViewCell {
    static let identifier = "DailyWeatherTableViewCell"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var summaryWeatherLabel: UILabel!
    
    
    func setup(with object: DailyWeather) {
        let date = Date(timeIntervalSince1970: object.datetimeEpoch)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        let formattedDate = dateFormatterPrint.string(from: date)
        dateLabel.text = formattedDate

        summaryWeatherLabel.text = object.description
    }
}
