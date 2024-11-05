//
//  CommunityPostWriteViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 11/5/24.
//

import UIKit
import Combine

final class CommunityPostWriteViewController: NavigationBarLeftBackButtonViewController {
    private var viewModel: CommunityPostWriteViewModel
    private var rootView = CommunityPostWriteRootView()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CommunityPostWriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "게시글 작성"
    }
}

extension CommunityPostWriteViewController {
    private func setupMenu() {
        var actions: [UIAction] = []
        CommunityPostCategory.allCases.forEach { category in
            guard category != .all else { return }
            let action = UIAction(title: category.rawValue) { [weak self] _ in
                self?.viewModel.process(.changeCategory(category))
            }
            actions.append(action)
        }
        let menu = UIMenu(title: "게시판 선택", children: actions)
        rootView.selectBoardButton.menu = menu
        rootView.selectBoardButton.showsMenuAsPrimaryAction = true
    }
}
