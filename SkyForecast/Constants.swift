//
//  Constants.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import Foundation

struct Constants {
    enum Storyboards {
        static var notAuthorizedFlow: String { "NotAuthorizedFlow" }
    }
    
    enum Segue {
        static var presentAuthorization: String { "presentAuthorization" }
        static var showDetailedWeather: String { "showDetailedWeather" }
    }
}
