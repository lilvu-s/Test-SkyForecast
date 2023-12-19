//
//  WeekWeather.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import Foundation

struct WeekWeather: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let description: String
    
    let days: [DailyWeather]
}

