//
//  EvaluationViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/2/24.
//

import UIKit
import Combine

protocol EvaluationViewControllerDelegate: AnyObject {
    func evaluationDidUpdate()
}

final class EvaluationViewController: NavigationBarLeftBackButtonViewController, NavigationBarHideable, LoadingDisplayable, Alertable {
    weak var delegate: EvaluationViewControllerDelegate?
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
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNavigationBar(animated: true)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "평가"
    }
}

extension EvaluationViewController {
    private func setupBindings() {
        bindEvaluationData()
        bindSituationKeyword()
        handleEvaluationButton()
        bindState()
    }
    
    private func bindState() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .inital:
                    return
                case .pop:
                    self?.viewModel.didTapBackButton()
                case .isLoading(let isLoading):
                    if isLoading {
                        self?.showLoadingView()
                    } else {
                        self?.hideLoadingView()
                    }
                case .errorAlert(let error):
                    if let _ = error as? NetworkError {
                        self?.showAlert(title: "평가 실패", message: "다시 시도해 주세요.")
                    } else {
                        self?.showAlert(title: "에러", message: error.localizedDescription)
                    }
                case .success:
                    self?.delegate?.evaluationDidUpdate()
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindEvaluationData() {
        viewModel.evaluationDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.tableViewHandler?.reload()
            }
            .store(in: &cancellables)
    }
    
    private func bindSituationKeyword() {
        viewModel.situationsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.updateEvaluationReceiveKeyword()
                self?.tableViewHandler?.keywordReload()
            }
            .store(in: &cancellables)
    }
    
    
    private func handleEvaluationButton() {
        evaluationView.evaluationFloatingView.onTapEvaluateButton = { [weak self] in
            self?.viewModel.submitEvaluation()
        }
    }
}
