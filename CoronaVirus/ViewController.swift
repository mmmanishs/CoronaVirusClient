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
    var viewModel: ModuleController.ViewModel!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        module = ModuleController(viewController: self)

    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }


}

extension ViewController: ControllableViewController {
    func loading() {

    }

    func errorLoading() {

    }

    func update(viewModel: ModuleController.ViewModel) {

    }


}

