//
//  NetworkManager.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Config
fileprivate class NetworkConfig {
    static let baseURL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"
    static let apiKey = "?unitGroup=metric&key=3YL7EZFDPM4YQ7CVSMGCMS77Z&contentType=json"
    
    static var fullBaseURL: String {
        return baseURL + apiKey + "/"
    }
}

class NetworkManager {
    //MARK: - Properties
    
    func dailyWeather(for lat: Double, lon: Double, completion: @escaping ResponseCompletion){
        guard ReachabilityManager.shared.isReachable else {
            completion(false, UserError.noInternet, nil)
            return
        }

        
        let baseUrlString = NetworkConfig.baseURL + "\(lat),\(lon)" + NetworkConfig.apiKey
        let dailyForecastURL = baseUrlString
        
        
        guard let url = URL(string: dailyForecastURL) else {
            completion(false, UserError.custom("URL is notVlaid"), nil)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = RequestType.get
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.cachePolicy = .returnCacheDataElseLoad

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            
            guard error == nil else {
                print("Error while fetching remote rooms: \(String(describing: error))")
                completion(false, UserError.custom(error.debugDescription), nil)
                return
            }
            
            guard let dataToDecode = data else {
                print("Nil data received from request \(url)")
                completion(false, UserError.serverError, nil)
                return
            }
            
            do {
                
//                if let json = try JSONSerialization.jsonObject(with: dataToDecode, options: []) as? [String: Any] {
//                    // try to read out a string array
//                    
//                }
                
                let decoder = JSONDecoder()
                let model = try decoder.decode(WeekWeather.self, from: dataToDecode)
                completion(true, nil, model)
                
            } catch let error {
                print("Data could not be parsed! :'( \(error)")
                completion(false, UserError.serverError, nil)
            }
        }

        
        task.resume()
    }
    
    
}


