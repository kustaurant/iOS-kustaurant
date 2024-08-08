//
//  TierMapViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import UIKit
 
final class TierMapViewController: UIViewController {
    private var viewModel: TierMapViewModel
    private var tierMapView = TierMapView()
    private var mapHandler: NMFMapViewHandler?
    
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
    }
}
