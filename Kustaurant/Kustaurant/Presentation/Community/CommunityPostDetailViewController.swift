//
//  CommunityPostDetailViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 10/27/24.
//

import UIKit

final class CommunityPostDetailViewController: UIViewController {
    private var rootView = CommunityPostDetailRootView()
    private var viewModel: CommunityPostDetailViewModel
    
    init(viewModel: CommunityPostDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
}

extension CommunityPostDetailViewController {
    private func setupNavigationBar() {
        title = "자유게시판"
    }
}
