//
//  MyPageViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit
import Combine

final class MyPageViewController: UIViewController {
    
    private let viewModel: MyPageViewModel
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
        setupNavigation()
        myPageTableViewHandler?.setupTableView()
        bindViews()
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
    }
}
