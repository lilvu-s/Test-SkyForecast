//
//  DailyWeather.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import Foundation
// fdfdf

struct DailyWeather: Codable {
    var description: String
    var conditions: String
    var icon: String
    
    var datetimeEpoch: TimeInterval
    
    var tempmax: Double
    var feelslikemax: Double
    var tempmin: Double
    var feelslikemin: Double
    
    var windspeed: Double
    var visibility: Double
    
    var humidity: Double
    var pressure: Double
    
    var temp: Double // станом на зараз
    var feelslike: Double // станом на зараз
}
