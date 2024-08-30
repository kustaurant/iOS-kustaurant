//
//  SavedRestaurantsTableViewHandler.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/29/24.
//

import UIKit

final class SavedRestaurantsTableViewHandler: NSObject {
    
    private let view: SavedRestaurantsView
    private let viewModel: SavedRestaurantsViewModel
    
    init(view: SavedRestaurantsView, viewModel: SavedRestaurantsViewModel) {
        self.view = view
        self.viewModel = viewModel
        super.init()
        self.setupTableView()
    }
}

extension SavedRestaurantsTableViewHandler {
    
    private func setupTableView() {
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.separatorStyle = .none
        view.tableView.registerCell(ofType: SavedRestaurantsTableViewCell.self)
        view.tableView.showsVerticalScrollIndicator = false
    }
    
    func reloadData() {
        view.tableView.reloadData()
    }
}

extension SavedRestaurantsTableViewHandler: UITableViewDelegate {
}

extension SavedRestaurantsTableViewHandler: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        66
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedRestaurantsTableViewCell.reuseIdentifier) as? SavedRestaurantsTableViewCell else {
            return UITableViewCell()
        }
        let restaurant = viewModel.favoriteRestaurants[indexPath.row]
        cell.model = restaurant
        return cell
    }
}
