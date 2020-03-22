//
//  SearchBar(CountryListVC).swift
//  CoronaVirus
//
//  Created by Manish Singh on 3/22/20.
//  Copyright © 2020 Manish Singh. All rights reserved.
//

import UIKit

extension CountryListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] timer in
            timer.invalidate()
            self?.module?.searchTextEntered(searchText: searchBar.text ?? "")
        }
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            module?.searchTextEntered(searchText: searchBar.text ?? "")
        }
    }
}
