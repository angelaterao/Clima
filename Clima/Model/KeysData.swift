//
//  KeysData.swift
//  Clima
//
//  Created by Angela Terao on 03/09/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit

struct KeysData {
    
    func getAPIKey() -> String {
        
        var apiKey: String
        
        let decoder = JSONDecoder()
        
        guard let sourcesURL = Bundle.main.url(forResource: "Keys", withExtension: "json") else { fatalError("Could not find json file") }
        
        guard let keysData = try? Data(contentsOf: sourcesURL) else {
                        fatalError("Could not cover data")
        }
        
        guard let keys = try? decoder.decode(Keys.self, from: keysData) else {
                        fatalError("Could not parse data")
        }
        
        apiKey = keys.API_Key
        
        return apiKey
    }
    
}

struct Keys: Decodable {
    let API_Key: String
}


