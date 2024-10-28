//
//  CommunityPostDetailRootView.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import UIKit

final class CommunityPostDetailRootView: UIView {
    private let tableView: CommunityPostDetailTableView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommunityPostDetailRootView {
    private func setupStyle() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        addSubview(tableView, autoLayout: [.fill(0)])
    }
}
