//
//  ControllableVC(CountryListVC).swift
//  CoronaVirus
//
//  Created by Manish Singh on 3/22/20.
//  Copyright © 2020 Manish Singh. All rights reserved.
//

import UIKit
extension CountryListViewController: ControllableViewController {
    func loading() {
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = false
            self.collectionView.alpha = 0.8
        }
    }

    func errorLoading() {
        DispatchQueue.main.async {
            self.collectionView.alpha = 1.0
            self.activityIndicatorView.isHidden = true
        }
    }

    func update(viewModel: ViewModel) {
        self.viewModel = viewModel
        DispatchQueue.main.async {
            self.collectionView.alpha = 1.0
            self.collectionView.reloadData()
            self.activityIndicatorView.isHidden = true
            self.setNavigationTitleView()
            self.worldInfoLabel.text = viewModel.worldSummary
        }
    }
}
