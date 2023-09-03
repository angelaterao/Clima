//
//  WeatherManager.swift
//  Clima
//
//  Created by Angela Terao on 07/11/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    //going to help us be able to pass errors of the WeatherManager
}

struct WeatherManager {
    
    var weatherURL: String
    
    init() {
        let keyData = KeysData()
        let apiKey = keyData.getAPIKey()
        weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric&units=metric"
    }
    
    var delegate: WeatherManagerDelegate?
    
    mutating func fetchWeather(cityName: String) {
        print(weatherURL)
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    mutating func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    //Networking action (similar to put the address on the browser in the search bar and hitting enter)
    func performRequest(with urlString: String) {
        //1. Create a URL - we use the URL initilizer (struct), that creates an optional URL
        if let url = URL(string: urlString) {
            
            //2. Create a URLSession - object that's gonna do the networking / browser
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task - similar to put the url in the search bar
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            print("Send request to weather api : ", url)
            
            //4. Start the task - similar to hit enter in the search bar
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        print("Receive response from weather api")
        
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let city = decodeData.name
            
            let weatherModel = WeatherModel(conditionID: id, cityName: city, temperature: temp)
            
            return weatherModel
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    

    
}

