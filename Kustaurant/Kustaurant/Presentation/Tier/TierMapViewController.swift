//
//  TierMapViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import UIKit
import CoreLocation
import Combine
 
final class TierMapViewController: UIViewController {
    private var viewModel: TierMapViewModel
    private var tierMapView = TierMapView()
    private var mapHandler: NMFMapViewHandler?
    private var categoriesCollectionViewHandler: TierTopCategoriesCollectionViewHandler?
    private let locationManager = CLLocationManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: TierMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        mapHandler = NMFMapViewHandler(
            view: tierMapView,
            viewModel: viewModel
        )
        categoriesCollectionViewHandler = TierTopCategoriesCollectionViewHandler(
            view: tierMapView,
            viewModel: viewModel
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = tierMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchTierMap()
        setupLocationManager()
        setupBindings()
    }
}

extension TierMapViewController {
    private func setupBindings() {
        bindMapRestaurants()
        bindCategories()
        bindCategoryButton()
    }
    
    private func bindMapRestaurants() {
        viewModel.mapRestaurantsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.mapHandler?.updateMap(data)
            }.store(in: &cancellables)
    }
    
    private func bindCategories() {
        viewModel.categoriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.categoriesCollectionViewHandler?.reloadData()
                self?.viewModel.fetchTierMap()
            }.store(in: &cancellables)
    }
    
    private func bindCategoryButton() {
        tierMapView.topCategoriesView.categoryButton.addAction(UIAction { [weak self] _ in
            self?.viewModel.categoryButtonTapped()
        }, for: .touchUpInside)
    }
}

extension TierMapViewController {
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - TierCategoryReceivable
extension TierMapViewController: TierCategoryReceivable {
    func receiveTierCategories(categories: [Category]) {
        viewModel.updateCategories(categories: categories)
    }
}
