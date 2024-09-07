//
//  MyEvaluationViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/7/24.
//

import UIKit
import Combine

class MyEvaluationViewController: UIViewController {
    
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
        setupNavigationBar()
        bind()
        tableViewHandler?.setupTableView()
        viewModel.getEvaluatedRestaurants()
    }
    
    override func loadView() {
        view = myEvaluationView
    }
}

extension MyEvaluationViewController {
    
    private func bind() {
        viewModel.evaluatedRestaurantsPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] restaurants in
                if restaurants.isEmpty {
                    self?.myEvaluationView.emptyView.isHidden = false
                } else {
                    self?.myEvaluationView.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupNavigationBar() {
        let backImage = UIImage(named: "icon_back")
        let backButtonView = UIImageView(image: backImage)
        let backButton = UIBarButtonItem(customView: backButtonView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButtonView.addGestureRecognizer(tapGesture)
        backButtonView.isUserInteractionEnabled = true
        navigationItem.title = "내 평가"
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        viewModel.didTapBackButton()
    }
}
