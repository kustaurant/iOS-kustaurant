//
//  ProfileComposeViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/29/24.
//

import UIKit

class ProfileComposeViewController: UIViewController {
    
    private var viewModel: ProfileComposeViewModel
    
    init(viewModel: ProfileComposeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigation()
    }
}

extension ProfileComposeViewController {
    
    func setupNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
