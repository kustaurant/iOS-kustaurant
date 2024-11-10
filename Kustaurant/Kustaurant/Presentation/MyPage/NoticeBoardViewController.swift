//
//  NoticeBoardViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/30/24.
//

import UIKit
import Combine

class NoticeBoardViewController: NavigationBarLeftBackButtonViewController {
    
    private let noticeBoardView = NoticeBoardView()
    private let viewModel: NoticeBoardViewModel
    private var tableViewHandler: NoticeBoardTableViewHandler?
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: NoticeBoardViewModel) {
        self.viewModel = viewModel
        self.tableViewHandler = NoticeBoardTableViewHandler(view: noticeBoardView, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableViewHandler?.setupTableView()
        bind()
        viewModel.getNoticeList()
    }
    
    override func loadView() {
        view = noticeBoardView
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "공지사항"
    }
}

extension NoticeBoardViewController {
    
    private func bind() {
        viewModel.noticeListPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] noticeList in
            self?.tableViewHandler?.reloadData()
        }
        .store(in: &cancellables)
    }
}
