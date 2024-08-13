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
        
        viewModel.isFetchingRestaurantsPublisher
            .sink { [weak self] isFetchingRestaurants in
                if isFetchingRestaurants {
                    self?.drawView.submitButton.buttonTitle = ""
                    self?.drawView.buttonLoadingIndicatorView.startAnimating()
                } else {
                    self?.drawView.submitButton.buttonTitle = "랜덤 뽑기"
                    self?.drawView.buttonLoadingIndicatorView.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.showAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showAlert in
                if showAlert {
                    self?.presentAlert()
                }
            }
            .store(in: &cancellables)
        
        drawView.submitButton.tapPublisher().sink { [weak self] in
            self?.viewModel.didTapDrawButton()
        }
        .store(in: &cancellables)
    }
}

extension DrawViewController {
                    
    private func presentAlert() {
        let alert = UIAlertController(title: "해당 조건에 맞는 식당이 없습니다.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.viewModel.didTapOkInAlert()
        }))
        present(alert, animated: true, completion: nil)
    }
}
