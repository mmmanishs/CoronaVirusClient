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

struct AppSettings: Codable {
    var bookMarkedCountries: [String]
}

extension AppSettings {
    static var appSettingsDirectory: URL {
        // find all possible documents directories for this user
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return path.appendingPathComponent("app-settings")
    }

    static func load() -> AppSettings {
        guard let data = try? Data(contentsOf: AppSettings.appSettingsDirectory) else {
            return AppSettings(bookMarkedCountries: [])
        }
        return try! JSONDecoder().decode(AppSettings.self, from: data)
    }

    func save() {
        guard let data = try? JSONEncoder().encode(self) else {
            return
        }
        try? data.write(to: AppSettings.appSettingsDirectory)
    }
}

