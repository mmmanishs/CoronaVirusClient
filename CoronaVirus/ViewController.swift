//
//  ViewController.swift
//  CoronaVirus
//
//  Created by Manish Singh on 3/14/20.
//  Copyright © 2020 Manish Singh. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    var module: ModuleController?
    var viewModel: ViewModel = ViewModel(rows: [])

    var timer: Timer?
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitleView()
        module = ModuleController(viewController: self)
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.updateCell(row: viewModel.rows[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.searchTextField.resignFirstResponder()
    }


}

extension ViewController: ControllableViewController {
    func loading() {
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = false
            self.tableView.alpha = 0.8
        }
    }

    func errorLoading() {
        DispatchQueue.main.async {
            self.tableView.alpha = 1.0
            self.activityIndicatorView.isHidden = true
        }
    }

    func update(viewModel: ViewModel) {
        self.viewModel = viewModel
        DispatchQueue.main.async {
            self.tableView.alpha = 1.0
            self.tableView.reloadData()
            self.activityIndicatorView.isHidden = true
        }
    }
}

extension ViewController: UISearchBarDelegate {
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

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.module?.searchTextEntered(searchText: "")
        searchBar.searchTextField.resignFirstResponder()
    }
}
