//
//  ViewModel.swift
//  CoronaVirus
//
//  Created by Manish Singh on 3/14/20.
//  Copyright © 2020 Manish Singh. All rights reserved.
//

import Foundation

extension CountryListViewController {
    struct ViewModel {
        var worldSummary: String = ""
        var rows: [Row]
        var bookmarkedRows: [Row] = []
        var numberOfRows: Int {
            return rows.count
        }
        struct Row {
            let country: String
            let cases, todayCases, deaths, todayDeaths: Int
            let recovered, critical: Int
            var isBookmarked: Bool
            static func empty() -> Row {
                return Row(country: "", cases: 0, todayCases: 0, deaths: 0, todayDeaths: 0, recovered: 0, critical: 0, isBookmarked: false)
            }
        }

        func getRow(for indexPath: IndexPath) -> Row {
            switch indexPath.section {
            case 0:
                return bookmarkedRows[indexPath.row]
            case 1:
                return rows[indexPath.row]
            default: return Row.empty()
            }
        }

        func getHeader(for section: Int) -> String {
            switch section {
            case 0:
                return "Bookmarked (Tap to remove)"
            case 1:
                return "All cases (Tap to bookmark)"
            default: return "Something is wrong with the app"
            }
        }


        func numberOfRows(for section: Int) -> Int {
            switch section {
            case 0:
                return bookmarkedRows.count
            case 1:
                return rows.count
            default: return 0
            }
        }

        static func initial() -> ViewModel {
            return ViewModel(remoteModel: [])
        }
    }
}

extension CountryListViewController.ViewModel {
    init(remoteModel: RemoteDataManager.CountryList,
         worldSummary: RemoteDataManager.WorldSummary? = nil,
         bookmarks: [String]? = []) {
        let bookmarks = AppSettings.load().bookMarkedCountries
        rows = remoteModel.map { countryCase in
            return CountryListViewController.ViewModel.Row(country: countryCase.country, cases: countryCase.cases, todayCases: countryCase.todayCases, deaths: countryCase.deaths, todayDeaths: countryCase.todayDeaths, recovered: countryCase.recovered, critical: countryCase.critical, isBookmarked: bookmarks.contains(countryCase.country))
        }
        if let worldSummary = worldSummary {
            self.worldSummary = "Cases \(worldSummary.cases), deaths: \(worldSummary.deaths), recovered: \(worldSummary.recovered)"
        }
        bookmarkedRows = rows.filter {$0.isBookmarked}
    }

    func reload() -> CountryListViewController.ViewModel {
        var newViewModel = self
        let bookmarks = AppSettings.load().bookMarkedCountries
        let newRows: [Row] = self.rows.map { row in
            var newRow = row
            newRow.isBookmarked = bookmarks.contains(row.country)
            return newRow
        }
        newViewModel.rows = newRows
        newViewModel.bookmarkedRows = newRows.filter {$0.isBookmarked}
        return newViewModel
    }
}
