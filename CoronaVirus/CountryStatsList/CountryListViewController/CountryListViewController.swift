//
//  CountryListViewController.swift
//  CoronaVirus
//
//  Created by Manish Singh on 3/14/20.
//  Copyright © 2020 Manish Singh. All rights reserved.
//

import UIKit


class CountryListViewController: UIViewController {
    let noOfCellsInRow = UIScreen.main.bounds.size.width / 400
    var module: CountryListModuleController?
    var viewModel = ViewModel.initial()

    var timer: Timer?
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var worldInfoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitleView()
        module = CountryListModuleController(viewController: self)
        DispatchQueue.global().async {
            self.module?.viewControllerInitialLoad()
        }
    }
    
    func setNavigationTitleView() {
        let attributesNormal: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            .foregroundColor: UIColor.red,
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributesNormal
        self.title = "COVID-19 Cases"
    }

    @IBAction func buttonRefreshTapped(_ sender: Any) {
        searchBar.text = ""
        searchBar.searchTextField.resignFirstResponder()
        DispatchQueue.global().async {
            self.module?.refreshButtonTapped()
        }
    }
}





