//
//  TierView.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import UIKit

final class TierView: UIView {
    lazy var pageViewController = TierPageViewController()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TierView {
    private func setupUI() {
        addSubviews()
        setupConstraint()
    }
    
    private func addSubviews() {
        [pageViewController.view].forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
