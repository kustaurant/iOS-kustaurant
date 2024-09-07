//
//  MyEvaluationTableViewHandler.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/7/24.
//

import UIKit

final class MyEvaluationTableViewHandler: NSObject {
    
    private let view: MyEvaluationView
    private let viewModel: MyEvaluationViewModel
    
    init(view: MyEvaluationView, viewModel: MyEvaluationViewModel) {
        self.view = view
        self.viewModel = viewModel
        super.init()
        self.setupTableView()
    }
}

extension MyEvaluationTableViewHandler {
    
    func setupTableView() {
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.separatorStyle = .none
        view.tableView.registerCell(ofType: MyEvaluationTableViewCell.self)
        view.tableView.showsVerticalScrollIndicator = false
    }
    
    func reloadData() {
        view.tableView.reloadData()
    }
}

extension MyEvaluationTableViewHandler: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let restaurant = viewModel.evaluatedRestaurants[indexPath.row]
        viewModel.didTapRestaurant(restaurantId: restaurant.restaurantId ?? 0)
    }
}

extension MyEvaluationTableViewHandler: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.evaluatedRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyEvaluationTableViewCell.reuseIdentifier) as? MyEvaluationTableViewCell else {
            return UITableViewCell()
        }
        let restaurant = viewModel.evaluatedRestaurants[indexPath.row]
        cell.model = restaurant
        return cell
    }
}
