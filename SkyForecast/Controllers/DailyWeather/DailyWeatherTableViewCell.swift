//
//  DailyWeatherTableViewCell.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import UIKit

final class DailyWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelLikeLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var summaryWeatherLabel: UILabel!
    
    func setup(with data: DailyWeather) {
        dateLabel.text = formattedDate(from: data.datetimeEpoch)
        tempLabel.text = "\(Int(data.temp.rounded()))°C"
        feelLikeLabel.text = "Feels Like\n \(Int(data.feelslike.rounded()))°C"
        summaryWeatherLabel.text = "\(data.description)"
        
        conditionLabel.attributedText = conditionAttributedString(for: data)
    }
    
    private func formattedDate(from epochTime: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: epochTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func conditionAttributedString(for data: DailyWeather) -> NSAttributedString {
        let conditionEmojis = data.conditions
            .split(separator: ",")
            .map { Constants.emoji(for: String($0).trimmingCharacters(in: .whitespaces)) }
            .joined(separator: " ")
        
        let conditionString = "\(conditionEmojis) \(data.conditions)"
        
        let attributedString = NSMutableAttributedString(string: conditionString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        return attributedString
    }
}
