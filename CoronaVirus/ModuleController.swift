//
//  ModuleController.swift
//  CoronaVirus
//
//  Created by Manish Singh on 3/14/20.
//  Copyright © 2020 Manish Singh. All rights reserved.
//

import UIKit

protocol ControllableViewController: class {
    func loading()
    func errorLoading()
    func update(viewModel: ModuleController.ViewModel)
}
class ModuleController {
    weak var viewController: ControllableViewController?
    let remoteDataManager = RemoteDataManager()
    
    init(viewController: ControllableViewController) {
        self.viewController = viewController
    }

    func viewControllerInitialLoad() {
        viewController?.loading()
    }

    func refreshButtonTapped() {
        viewController?.loading()
        remoteDataManager.fetchData { [weak self]  result in
            switch result {
            case .success(let remoteModel):
                self?.viewController?.update(viewModel: ViewModel(remoteModel: remoteModel))
            case .failure(_):
                self?.viewController?.loading()
            }
        }
    }

    enum State {
        case loading
        case loaded(ViewModel)
    }

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
}

extension ModuleController.ViewModel {
    init(remoteModel: RemoteDataManager.CountryList) {
        var rows = [ModuleController.ViewModel.Row]()
        for countryCase in remoteModel {
            let row = ModuleController.ViewModel.Row(country: countryCase.country, cases: countryCase.cases, todayCases: countryCase.todayCases, deaths: countryCase.deaths, todayDeaths: countryCase.todayDeaths, recovered: countryCase.recovered, critical: countryCase.critical)
            rows.append(row)
        }
        self.rows = rows
    }
}


