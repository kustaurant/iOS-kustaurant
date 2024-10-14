//
//  CommunityViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit
import Combine

final class CommunityViewController: UIViewController, LoadingDisplayable {
    private let viewModel: CommunityViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: CommunityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelAction()
        viewModel.process(.fetchPosts)
    }
}

extension CommunityViewController {
    private func bindViewModelAction() {
        viewModel.actionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .showLoading(let isLoading):
                    if isLoading {
                        self?.showLoadingView()
                    } else {
                        self?.hideLoadingView()
                    }
                case .didFetchPosts:
                    self?.viewModel.posts.forEach {
                        print("---------------------")
                        print($0)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
