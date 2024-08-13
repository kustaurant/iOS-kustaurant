//
//  DrawResultViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/10/24.
//

import UIKit
import Combine

class DrawResultViewController: UIViewController {
    
    private var viewModel: DrawResultViewModel
    private let drawResultView = DrawResultView()
    private var cancellables = Set<AnyCancellable>()
    private var drawResultViewRouletteHandler: DrawResultRouletteHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        bind()
        viewModel.fetchDrawedRestaurants()
        drawResultViewRouletteHandler?.updateRestaurantRouletteView(restaurants: viewModel.restaurants)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drawResultViewRouletteHandler?.scrollToLastRestaurant()
        bindViews()
    }
    
    init(viewModel: DrawResultViewModel) {
        self.viewModel = viewModel
        self.drawResultViewRouletteHandler = DrawResultRouletteHandler(view: drawResultView, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = drawResultView
    }
}

extension DrawResultViewController {
    
    private func setupNavigationBar() {
        let searchImage = UIImage(named: "icon_search")
        let searchButtonView = UIImageView(image: searchImage)
        let searchButton = UIBarButtonItem(customView: searchButtonView)
        
        let bellImage = UIImage(named: "icon_bell_badged")
        let notificationButtonView = UIImageView(image: bellImage)
        let notificationButton = UIBarButtonItem(customView: notificationButtonView)
        
        let backImage = UIImage(named: "icon_back")
        let backButtonView = UIImageView(image: backImage)
        let backButton = UIBarButtonItem(customView: backButtonView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButtonView.addGestureRecognizer(tapGesture)
        backButtonView.isUserInteractionEnabled = true
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 16.0
        navigationItem.title = "랜덤 맛집 뽑기"
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [searchButton, space, notificationButton]
    }
    
    private func bind() {
        drawResultView.resetCategoryButton.tapPublisher()
            .sink { [weak self] in
                self?.backButtonTapped()
            }
            .store(in: &cancellables)
        
        drawResultView.redrawButton.tapPublisher()
            .sink { [weak self] in
                self?.drawResultViewRouletteHandler?.resetRoulettes()
                self?.viewModel.didTapReDrawButton()
                self?.drawResultViewRouletteHandler?.scrollToLastRestaurant()
            }
            .store(in: &cancellables)
    }
    
    private func bindViews() {
        viewModel.restaurantsPublisher.sink { [weak self] restaurants in
            self?.drawResultViewRouletteHandler?.updateRestaurantRouletteView(restaurants: restaurants)
        }
        .store(in: &cancellables)
    }
    
    @objc private func backButtonTapped() {
        viewModel.didTapBackButton()
    }
}

