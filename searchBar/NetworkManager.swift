//
//  NetworkManager.swift
//  searchBar
//
//  Created by Abdalla on 9/21/19.
//  Copyright © 2019 edu.data. All rights reserved.
//

import Foundation
class NetworkManager {
    
    func getDataFromServer(path: String, callback: @escaping ((Data) -> ())) {
        
        let serverUrl = "https://restcountries.eu/rest/v2/"
        
        let url = URL(string: serverUrl + "lang/ar")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                //self.handleClientError(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print(response as Any)
                    //self.handleServerError(response)
                    return
            }
            if let data = data{
                let string = String(data: data, encoding: .utf8)
                callback(data)
            }
        }
        task.resume()
    }
}
