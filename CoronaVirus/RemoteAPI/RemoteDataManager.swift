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
//    let url = URL(string: "https://corona.lmao.ninja/countries")!

    func fetchData(completionHandler: @escaping(Result<CountryList, APIError>) -> Void) {
        let url = URL(string: "https://coronavirus-19-api.herokuapp.com/countries")!

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

    func fetchSummary(completionHandler: @escaping(Result<WorldSummary, APIError>) -> Void) {
        let url = URL(string: "https://coronavirus-19-api.herokuapp.com/all")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            guard let data = data,
                error == nil else {
                    completionHandler(.failure(.apiCallFailed))
                    return
            }
            if let worldSummary = try? JSONDecoder().decode(WorldSummary.self, from: data) {
                completionHandler(.success(worldSummary))
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

    struct WorldSummary: Codable {
        let cases, deaths, recovered: Int
    }

    typealias CountryList = [CountryCase]

}
