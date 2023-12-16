//
//  NetworkManager.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import Foundation

final class NetworkManager {
    typealias ResponseCompletion = (Bool, UserError?, WeekWeather?) -> Void

    func dailyWeather(for lat: Double, lon: Double, completion: @escaping ResponseCompletion) {
        let router = WeatherRouter()
        let route = router.dailyWeather(lat: lat, lon: lon)
        
        guard ReachabilityManager.shared.isReachable else {
            completion(false, UserError.noInternet, nil)
            return
        }

        do {
            let request = try route.asURLRequest()
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    completion(false, UserError.custom(error!.localizedDescription), nil)
                    return
                }

                guard let data = data else {
                    completion(false, UserError.serverError, nil)
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(WeekWeather.self, from: data)
                    completion(true, nil, model)
                } catch {
                    completion(false, UserError.serverError, nil)
                }
            }
            task.resume()
        } catch {
            completion(false, UserError.custom("Invalid URL"), nil)
        }
    }
}

