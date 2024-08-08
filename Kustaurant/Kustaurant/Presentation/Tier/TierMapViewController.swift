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
        bindmapRestaurants()
    }
    
    private func bindmapRestaurants() {
        viewModel.mapRestaurantsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.mapHandler?.addMapOverlay(data)
            }.store(in: &cancellables)
    }
}

extension TierMapViewController {
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
    }
}
