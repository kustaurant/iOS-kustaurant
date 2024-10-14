//
//  CommunityViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class CommunityViewController: UIViewController {
    private let viewModel: CommunityViewModel
    
    init(viewModel: CommunityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
