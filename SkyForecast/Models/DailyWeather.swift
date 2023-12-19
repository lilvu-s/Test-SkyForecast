//
//  DailyWeather.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import Foundation

struct DailyWeather: Codable {
    let description: String
    let conditions: String
    let icon: String
    
    let datetimeEpoch: TimeInterval
    
    let tempmax: Double
    let feelslikemax: Double
    let tempmin: Double
    let feelslikemin: Double
    
    let windspeed: Double
    let visibility: Double
    
    let humidity: Double
    let pressure: Double
    
    let temp: Double // станом на зараз
    let feelslike: Double // станом на зараз
}
