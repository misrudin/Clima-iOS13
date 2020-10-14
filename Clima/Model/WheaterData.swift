//
//  WheaterData.swift
//  Clima
//
//  Created by BMG MacbookPro on 12/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WheaterData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
