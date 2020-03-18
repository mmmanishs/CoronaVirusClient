//
//  CountryListViewController.swift
//  CoronaVirus
//
//  Created by Manish Singh on 3/14/20.
//  Copyright © 2020 Manish Singh. All rights reserved.
//

import UIKit


class CountryListViewController: UIViewController {
    let noOfCellsInRow = 2
    var module: CountryListModuleController?
    var viewModel: ViewModel = ViewModel(rows: [])

    var timer: Timer?
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitleView()
        module = CountryListModuleController(viewController: self)
        DispatchQueue.global().async {
            self.module?.viewControllerInitialLoad()
        }
    }

    func setNavigationTitleView() {
        let font = UIFont.systemFont(ofSize: 25)
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.red
        shadow.shadowBlurRadius = 4

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black,
            .shadow: shadow
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
        title = "COVID-19 Cases"
    }

    @IBAction func buttonRefreshTapped(_ sender: Any) {
        searchBar.text = ""
        searchBar.searchTextField.resignFirstResponder()
        DispatchQueue.global().async {
            self.module?.refreshButtonTapped()
        }
    }
}
extension CountryListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryStatsCell", for: indexPath) as! CountryStatsCell
         cell.updateCell(row: viewModel.rows[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            searchBar.searchTextField.resignFirstResponder()
        }
}
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
        }
    }
}

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
            DispatchQueue.main.async {
                self.searchBar.searchTextField.resignFirstResponder()
            }
        }
    }
}
