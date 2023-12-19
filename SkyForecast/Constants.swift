//
//  Constants.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import Foundation

final class Constants {
    typealias Coordinates = (lat: Double, lon: Double)
    
    enum Storyboards {
        static var notAuthorizedFlow: String { "NotAuthorizedFlow" }
    }
    
    enum Segue {
        static var presentAuthorization: String { "presentAuthorization" }
        static var showDetailedWeather: String { "showDetailedWeather" }
    }
    
    enum Weather {
        static let defaultLat = 37.8267
        static let defaultLon = -122.4233
 
        static let weatherCellIdentifier = "DailyWeatherTableViewCell"
    }
    
    enum UserType {
        case anonymous
        case authorized
    }
    
    static func emoji(for condition: String) -> String {
        switch condition {
        case "Clear":
            return "☀️"
        case "Rain":
            return "🌨️"
        case "Overcast":
            return "☁️"
        case "Partially cloudy":
            return "⛅️"
        case "Snow":
            return "❄️"
        case "Thunderstorm":
            return "🌪️"
        default:
            return ""
        }
    }
}
