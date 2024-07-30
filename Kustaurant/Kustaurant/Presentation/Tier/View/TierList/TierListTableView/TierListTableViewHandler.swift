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
        view.tableView.separatorStyle = .none
    }
    
    func reloadData() {
        view.tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension TierListTableViewHandler: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        66
    }
}

// MARK: - UITableViewDataSource
extension TierListTableViewHandler: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.tierRestaurants.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TierListTableViewCell.reuseIdentifier, for: indexPath) as? TierListTableViewCell else { return UITableViewCell() }
        var model = viewModel.tierRestaurants[indexPath.row]
        model.index = indexPath.row + 1
        cell.model = model
        return cell
    }
}