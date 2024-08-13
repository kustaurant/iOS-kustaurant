//
//  RecommendViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit
import Combine

final class DrawViewController: UIViewController {
    
    private var viewModel: DrawViewModel
    private let drawView = DrawView()
    
    private var collectionViewHandler: DrawCollectionViewHandler?
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: DrawViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.collectionViewHandler = DrawCollectionViewHandler(view: drawView, viewModel: viewModel)
        self.collectionViewHandler?.setupCollectionView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        bind()
    }
    
    override func loadView() {
        view = drawView
    }
}

extension DrawViewController {
    
    private func setupNavigationBar() {
        let searchImage = UIImage(named: "icon_search")
        let bellImage = UIImage(named: "icon_bell_badged")
        let searchButtonView = UIImageView(image: searchImage)
        let notificationButtonView = UIImageView(image: bellImage)
        let searchButton = UIBarButtonItem(customView: searchButtonView)
        let notificationButton = UIBarButtonItem(customView: notificationButtonView)
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 16.0
        navigationItem.title = "랜덤 맛집 뽑기"
        navigationItem.rightBarButtonItems = [searchButton, space, notificationButton]
    }
    
    private func bind() {
        viewModel.collectionViewSectionsPublisher
            .sink { [weak self] sectionModels in
                self?.collectionViewHandler?.applySnapshot(sectionModels: sectionModels)
            }
            .store(in: &cancellables)
        
        drawView.submitButton.tapPublisher().sink { [weak self] in
            self?.viewModel.didTapDrawButton()
        }
        .store(in: &cancellables)
    }
}
