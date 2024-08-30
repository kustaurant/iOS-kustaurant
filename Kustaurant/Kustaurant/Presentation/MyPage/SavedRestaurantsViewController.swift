//
//  SavedRestaurantsViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/29/24.
//

import UIKit
import Combine

class SavedRestaurantsViewController: UIViewController {
    
    private let viewModel: SavedRestaurantsViewModel
    private var cancellables = Set<AnyCancellable>()
    private let savedRestaurantsView = SavedRestaurantsView()
    private var savedRestaurantsTableViewHandler: SavedRestaurantsTableViewHandler?
    
    init(viewModel: SavedRestaurantsViewModel) {
        self.viewModel = viewModel
        self.savedRestaurantsTableViewHandler = SavedRestaurantsTableViewHandler(view: savedRestaurantsView, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        viewModel.getFavoriteRestaurants()
        bind()
    }
    
    override func loadView() {
        view = savedRestaurantsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension SavedRestaurantsViewController {
    
    private func bind() {
        viewModel.favoriteRestaurantsPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] restaurants in
                if restaurants.isEmpty {
                    self?.savedRestaurantsView.emptyView.isHidden = false
                } else {
                    self?.savedRestaurantsTableViewHandler?.reloadData()
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
        navigationItem.title = "저장된 맛집"
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        viewModel.didTapBackButton()
    }
}
