//
//  AppSettings.swift
//  CoronaVirus
//
//  Created by Manish Singh on 3/21/20.
//  Copyright © 2020 Manish Singh. All rights reserved.
//

import Foundation
struct AppSettings: Codable {
    var bookMarkedCountries: [String]

    static var shared: AppSettings = {
        return AppSettings.load()
    }()
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

