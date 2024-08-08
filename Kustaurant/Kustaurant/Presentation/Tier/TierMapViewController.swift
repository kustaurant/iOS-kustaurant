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
    
    // MARK: - Initialization
    init(viewModel: TierMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
