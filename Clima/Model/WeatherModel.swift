//
//  WeatherModel.swift
//  Clima
//
//  Created by Angela Terao on 09/11/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionID {
        case 0...299:
            return "cloud.bolt"
        case 300...399:
            return "cloud.drizzle"
        case 500...599:
            return "cloud.rain"
        case 600...699:
            return "cloud.snow"
        case 700...799:
            return "cloud.fog"
        case 801:
            return "sun.max"
        case 801...899:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}

