//
//  TableViewCell.swift
//  CoronaVirus
//
//  Created by Manish Singh on 3/14/20.
//  Copyright © 2020 Manish Singh. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var countryName: UILabel!
    @IBOutlet var countryFlag: UILabel!
    @IBOutlet var cases: UILabel!
    @IBOutlet var deaths: UILabel!
    @IBOutlet var recovered: UILabel!
    @IBOutlet var critical: UILabel!

    func updateCell(row: ViewModel.Row) {
        countryName.text = row.country
        countryFlag.text = row.country.countryFlag
        cases.text = "\(String(row.cases)) (\(String(row.todayCases)))"
        deaths.text = "\(String(row.deaths)) (\(String(row.todayDeaths)))"
        recovered.text = String(row.recovered)
        critical.text = String(row.critical)
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
