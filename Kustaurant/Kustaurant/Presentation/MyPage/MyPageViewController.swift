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
        viewModel.getUserSavedRestaurants()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigation()
    }
    
    override func loadView() {
        view = myPageView
    }
}

extension MyPageViewController {
    
    private func setupNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func bindViews() {
        viewModel.isLoggedInPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loginStatus in
                self?.myPageTableViewHandler?.updateUI(by: loginStatus)
            }
            .store(in: &cancellables)
    }
    
    private func bindUserProfileView() {
        guard let headerView = myPageView.tableView.tableHeaderView as? MyPageUserProfileView else {
            return
        }
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(toggle))
        headerView.profileImageView.addGestureRecognizer(tapGesture)
        
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
    
    @objc func toggle() {
        viewModel.isLoggedIn = viewModel.isLoggedIn.toggle()
    }
}
