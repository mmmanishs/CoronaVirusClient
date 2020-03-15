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
    func update(viewModel: ViewModel)
}
class ModuleController {
    weak var viewController: ControllableViewController?
    let remoteDataManager = RemoteDataManager()
    var remoteModel: RemoteDataManager.CountryList?

    init(viewController: ControllableViewController) {
        self.viewController = viewController
    }

    func viewControllerInitialLoad() {
        refreshButtonTapped()
    }

    func refreshButtonTapped() {
        viewController?.loading()
        remoteDataManager.fetchData { [weak self]  result in
            switch result {
            case .success(let remoteModel):
                self?.remoteModel = remoteModel
                self?.viewController?.update(viewModel: ViewModel(remoteModel: remoteModel))
            case .failure(_):
                self?.viewController?.loading()
            }
        }
    }

    func searchTextEntered(searchText: String) {
        var filteredRowModel = remoteModel
        if !searchText.isEmpty {
            filteredRowModel = remoteModel?.filter { $0.country.uppercased().contains(searchText.uppercased())} ?? []
        }
        let viewModel = ViewModel(remoteModel: filteredRowModel ?? [])
        viewController?.update(viewModel: viewModel)
    }

    enum State {
        case loading
        case loaded(ViewModel)
    }
}



