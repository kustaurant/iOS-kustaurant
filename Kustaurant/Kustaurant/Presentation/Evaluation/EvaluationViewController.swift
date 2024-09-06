//
//  EvaluationViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/2/24.
//

import UIKit
import Combine

final class EvaluationViewController: UIViewController, NavigationBarHideable {
    
    private let viewModel: EvaluationViewModel
    private let evaluationView = EvaluationView()
    private var tableViewHandler: EvaluationTableViewHandler?
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: EvaluationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tableViewHandler = EvaluationTableViewHandler(view: evaluationView, viewModel: viewModel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = evaluationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNavigationBar(animated: true)
    }
}

extension EvaluationViewController {
    
    private func setupNavigationBar() {
        let backImage = UIImage(named: "icon_back")
        let backButtonView = UIImageView(image: backImage)
        let backButton = UIBarButtonItem(customView: backButtonView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButtonView.addGestureRecognizer(tapGesture)
        backButtonView.isUserInteractionEnabled = true
        navigationItem.title = "평가"
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        viewModel.didTapBackButton()
    }
}


extension EvaluationViewController {
    private func setupBindings() {
        bindEvaluationData()
    }
    
    private func bindEvaluationData() {
        viewModel.evaluationDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
            }
            .store(in: &cancellables)
    }
}
