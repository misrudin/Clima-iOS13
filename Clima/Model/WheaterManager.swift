//
//  WheaterManager.swift
//  Clima
//
//  Created by BMG MacbookPro on 12/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ wheaterManager: WheaterManager, weather: WeatherModel)
    func didFailWithError(_ error: Error)
}


struct WheaterManager {
    let wheaterUrl = "https://api.openweathermap.org/data/2.5/weather?appid=c55ca4e16462bf0eeaf77f42e2e02f22&units=metric"
    
    
    var delegate: WeatherManagerDelegate?
    
    func fethWheater(cityName: String){
        let urlString = "\(wheaterUrl)&q=\(cityName)"
        
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(wheaterData: safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(wheaterData: Data)-> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WheaterData.self, from: wheaterData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
        }catch{
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    
}
