//
//  RemoteDataManager.swift
//  CoronaVirus
//
//  Created by Manish Singh on 3/14/20.
//  Copyright © 2020 Manish Singh. All rights reserved.
//

import Foundation

class RemoteDataManager {
    enum APIError: Error {
        case apiCallFailed
    }
    let url = URL(string: "https://corona.lmao.ninja/countries")!

    func fetchData(completionHandler: @escaping(Result<CountryList, APIError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            guard let data = data,
                error == nil else {
                    completionHandler(.failure(.apiCallFailed))
                    return
            }
            if let countryList = try? JSONDecoder().decode([CountryCase].self, from: data) {
                completionHandler(.success(countryList))
            } else {
                completionHandler(.failure(.apiCallFailed))
            }
        }
        task.resume()
    }

    struct CountryCase: Codable {
        let country: String
        let cases, todayCases, deaths, todayDeaths: Int
        let recovered, critical: Int
    }

    typealias CountryList = [CountryCase]

}
