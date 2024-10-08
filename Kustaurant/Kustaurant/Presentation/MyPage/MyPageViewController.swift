//
//  MyPageViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit
import Combine

final class MyPageViewController: UIViewController {
    
    private var viewModel: MyPageViewModel
    private let myPageView = MyPageView()
    private var cancellables = Set<AnyCancellable>()
    private var myPageTableViewHandler: MyPageTableViewHandler?
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        self.myPageTableViewHandler = MyPageTableViewHandler(view: myPageView, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPageTableViewHandler?.setupTableView()
        bindViews()
        bindUserProfileView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel.getUserSavedRestaurants()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func loadView() {
        view = myPageView
    }
}

extension MyPageViewController {
    
    private func bindViews() {
        viewModel.isLoggedInPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loginStatus in
                self?.myPageTableViewHandler?.updateUI(by: loginStatus)
            }
            .store(in: &cancellables)
        
        viewModel.showAlertPublisher.sink { [weak self] showAlert in
            if showAlert {
                self?.presentAlert()
            }
        }
        .store(in: &cancellables)
        
        viewModel.tableViewSectionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.myPageTableViewHandler?.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func bindUserProfileView() {
        guard let headerView = myPageView.tableView.tableHeaderView as? MyPageUserProfileView else {
            return
        }
        
        headerView.profileButton.tapPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                if self?.viewModel.isLoggedIn == .loggedIn {
                    self?.viewModel.didTapComposeProfileButton()
                } else {
                    self?.viewModel.didTapLoginAndStartButton()
                }
            }
            .store(in: &cancellables)
        
        viewModel.userSavedRestaurantsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userSavedRestaurants in
                self?.myPageTableViewHandler?.updateSavedRestaurants(userSavedRestaurants)
            }
            .store(in: &cancellables)
    }
}

extension MyPageViewController {
    
    private func presentAlert() {
        let alert = UIAlertController(title: viewModel.alertPayload.title, message: viewModel.alertPayload.subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { [weak self] _ in
            self?.viewModel.dismissAlert()
        }))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.viewModel.alertPayload.onConfirm?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
