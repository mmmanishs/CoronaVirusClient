//
//  CountryListModuleController.swift
//  CoronaVirus
//
//  Created by Manish Singh on 3/14/20.
//  Copyright © 2020 Manish Singh. All rights reserved.
//

import UIKit

protocol ControllableViewController: class {
    func loading()
    func errorLoading()
    func update(viewModel: CountryListViewController.ViewModel)
}
class CountryListModuleController {
    weak var viewController: ControllableViewController?
    let remoteDataManager = RemoteDataManager()
    var remoteModel: RemoteDataManager.CountryList?
    var worldSummary: RemoteDataManager.WorldSummary?
    var viewModel: CountryListViewController.ViewModel!

    init(viewController: ControllableViewController) {
        self.viewController = viewController
    }

    func viewControllerInitialLoad() {
        refreshButtonTapped()
        fetchWorldSummary()
    }

    func refreshButtonTapped() {
        viewController?.loading()
        remoteDataManager.fetchData { [weak self]  result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let remoteModel):
                self.remoteModel = remoteModel
                self.viewModel = CountryListViewController.ViewModel(remoteModel: remoteModel, worldSummary: self.worldSummary)
                self.viewController?.update(viewModel: self.viewModel)
            case .failure(_):
                self.viewController?.errorLoading()
            }
        }
    }

    func fetchWorldSummary() {
        remoteDataManager.fetchSummary { [weak self]  result in
            switch result {
            case .success(let worldSummary):
                guard let self = self else {
                    return
                }
                self.worldSummary = worldSummary
                self.viewModel = CountryListViewController.ViewModel(remoteModel: self.remoteModel ?? [], worldSummary: worldSummary)
                self.viewController?.update(viewModel: self.viewModel)
            case .failure(_):
                self?.viewController?.errorLoading()
            }
        }
    }

    func cellSelected(countryName: String) {
        var bookmark = AppSettings.shared.bookMarkedCountries
        if let index = bookmark.firstIndex(of: countryName) {
            AppSettings.shared.bookMarkedCountries.remove(at: index)
        } else {
            AppSettings.shared.bookMarkedCountries.append(countryName)
        }
        AppSettings.shared.save()
        self.viewModel = self.viewModel.reload()
        self.viewController?.update(viewModel: self.viewModel)
    }

    func searchTextEntered(searchText: String) {
        var filteredRowModel = remoteModel
        if !searchText.isEmpty {
            filteredRowModel = remoteModel?.filter { $0.country.uppercased().contains(searchText.uppercased())} ?? []
        }
        let viewModel = CountryListViewController.ViewModel(remoteModel: filteredRowModel ?? [])
        viewController?.update(viewModel: viewModel)
    }

    enum State {
        case loading
        case loaded(CountryListViewController.ViewModel)
    }
}



