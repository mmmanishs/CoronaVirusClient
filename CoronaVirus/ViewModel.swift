//
//  ViewModel.swift
//  CoronaVirus
//
//  Created by Manish Singh on 3/14/20.
//  Copyright © 2020 Manish Singh. All rights reserved.
//

import Foundation

struct ViewModel {
    let rows: [Row]

    var numberOfRows: Int {
        return rows.count
    }
    struct Row {
        let country: String
        let cases, todayCases, deaths, todayDeaths: Int
        let recovered, critical: Int
    }
}
extension ViewModel {
    init(remoteModel: RemoteDataManager.CountryList) {
        var rows = [ViewModel.Row]()
        for countryCase in remoteModel {
            let row = ViewModel.Row(country: countryCase.country, cases: countryCase.cases, todayCases: countryCase.todayCases, deaths: countryCase.deaths, todayDeaths: countryCase.todayDeaths, recovered: countryCase.recovered, critical: countryCase.critical)
            rows.append(row)
        }
        self.rows = rows
    }
}
