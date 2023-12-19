//
//  WeatherRouter.swift
//  SkyForecast
//
//  Created by Angelina on 16.12.2023.
//  Copyright © 2023 HellySolovii. All rights reserved.
//

import Foundation

final class WeatherRouter {
    private let baseURL: String
    private var apiKey: String {
        return ProcessInfo.processInfo.environment["APIKey"] ?? ""
    }

    init(baseURL: String = NetworkURLs.baseURL) {
        self.baseURL = baseURL
    }

    func dailyWeather(lat: Double, lon: Double) -> Route {
        let path = NetworkURLs.Weather.daily.rawValue + "\(lat),\(lon)"
        let parameters = [
            "unitGroup": "metric",
            "key": apiKey,
            "contentType": "json"
        ]
        return Route(baseURL: baseURL, path: path, method: RequestType.get, parameters: parameters)
    }
}
