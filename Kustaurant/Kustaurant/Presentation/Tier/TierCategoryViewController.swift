//
//  TierCategoryViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/30/24.
//

import UIKit

final class TierCategoryViewController: UIViewController {
    private var viewModel: TierCategoryViewModel
    
    // MARK: - Initialization
    init(viewModel: TierCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
}

// MARK: - Actions
extension TierCategoryViewController {
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension TierCategoryViewController {
    private func setupUI() {
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let icon = UIImage(named: "icon_back")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.title = "카테고리"
    }
}
