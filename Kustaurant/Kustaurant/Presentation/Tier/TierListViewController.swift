//
//  TierListViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import UIKit

final class TierListViewController: UIViewController {
    private var viewModel: TierListViewModel
    
    // MARK: - Initialization
    init(viewModel: TierListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }
}
