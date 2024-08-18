//
//  TierListView.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import UIKit

final class TierListView: UIView {
    let tableView = UITableView()
    let topCategoriesView = TierTopCategoriesView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TierListView {
    private func setupUI() {
        backgroundColor = .white
        addSubviews()
        setupConstraint()
    }
    
    private func addSubviews() {
        [tableView, topCategoriesView].forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            topCategoriesView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 18),
            topCategoriesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topCategoriesView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topCategoriesView.heightAnchor.constraint(equalToConstant: Category.height),
            tableView.topAnchor.constraint(equalTo: topCategoriesView.bottomAnchor, constant: 9),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

}
