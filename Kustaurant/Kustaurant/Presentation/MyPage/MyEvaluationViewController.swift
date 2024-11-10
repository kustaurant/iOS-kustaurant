//
//  MyEvaluationViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/7/24.
//

import UIKit
import Combine

class MyEvaluationViewController: NavigationBarLeftBackButtonViewController {
    
    private let myEvaluationView = MyEvaluationView()
    private let viewModel: MyEvaluationViewModel
    private var cancellables = Set<AnyCancellable>()
    private var tableViewHandler: MyEvaluationTableViewHandler?
    
    init(viewModel: MyEvaluationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.tableViewHandler = MyEvaluationTableViewHandler(view: myEvaluationView, viewModel: viewModel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
        tableViewHandler?.setupTableView()
        viewModel.getEvaluatedRestaurants()
    }
    
    override func loadView() {
        view = myEvaluationView
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "내 평가"
    }
}

extension MyEvaluationViewController {
    
    private func bind() {
        viewModel.evaluatedRestaurantsPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] restaurants in
                if restaurants.isEmpty {
                    self?.myEvaluationView.emptyView.isHidden = false
                } else {
                    self?.myEvaluationView.emptyView.isHidden = true
                    self?.myEvaluationView.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
}
