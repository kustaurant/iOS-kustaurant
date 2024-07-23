//
//  TierListTableViewHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import Foundation
import UIKit

final class TierListTableViewHandler: NSObject {
    private var view: TierListView
    private var viewModel: TierListViewModel
    
    // MARK: - Initialization
    init(
        view: TierListView,
        viewModel: TierListViewModel
    ) {
        self.view = view
        self.viewModel = viewModel
        super.init()
        setupTalbieView()
    }
}

extension TierListTableViewHandler {
    private func setupTalbieView() {
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.register(TierListTableViewCell.self, forCellReuseIdentifier: TierListTableViewCell.reuseIdentifier)
    }
}

extension TierListTableViewHandler: UITableViewDelegate {
    
}

extension TierListTableViewHandler: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        10
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TierListTableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "Row \(indexPath.row + 1)"
        return cell
    }
}
