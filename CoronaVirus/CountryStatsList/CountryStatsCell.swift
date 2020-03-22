//
//  CollectionViewCell.swift
//  CoronaVirus
//
//  Created by Manish Singh on 3/14/20.
//  Copyright © 2020 Manish Singh. All rights reserved.
//

import UIKit

class CountryStatsCell: UICollectionViewCell {
    var rowModel: CountryListViewController.ViewModel.Row?
    @IBOutlet var bookmarkView: UIView!
    @IBOutlet var countryName: UILabel!
    @IBOutlet var countryFlag: UILabel!
    @IBOutlet var cases: UILabel!
    @IBOutlet var deaths: UILabel!
    @IBOutlet var recovered: UILabel!
    @IBOutlet var critical: UILabel!

    func updateCell(row: CountryListViewController.ViewModel.Row) {
        self.rowModel = row
        countryName.text = row.country
        countryFlag.text = row.country.countryFlag
        cases.text = "\(String(row.cases)) (\(String(row.todayCases)))"
        deaths.text = "\(String(row.deaths)) (\(String(row.todayDeaths)))"
        recovered.text = String(row.recovered)
        critical.text = String(row.critical)
        bookmarkView.backgroundColor = row.isBookmarked ? UIColor.blue : UIColor.clear
    }
}


extension String {
    var flag: String? {
        guard let locale = locale else {
            return nil
        }
        let base : UInt32 = 127397
        var s = ""
        for v in locale.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }

    private var locale: String? {
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale(localeIdentifier: localeCode)
            let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
            if lowercased() == countryName?.lowercased() {
                return localeCode
            }
        }
        return nil
    }

}


class CountryStatsSectionHeader: UICollectionReusableView {
    @IBOutlet var sectionHeaderlabel: UILabel!
}
