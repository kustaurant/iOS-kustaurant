//
//  HomeView.swift
//  Kustaurant
//
//  Created by 송우진 on 7/17/24.
//

import UIKit

final class HomeView: UIView {

    let homeLayoutTableView = HomeLayoutTableView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView {
    private func setupUI() {
        addSubview(homeLayoutTableView, autoLayout: [.top(0), .bottomSafeArea(constant: 0), .leading(0), .trailing(0)])
    }
}
