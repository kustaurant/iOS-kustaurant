//
//  TierListView.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import UIKit

final class TierListView: UIView {
    let tableView = UITableView()
    
    private let categoryContainer = UIView()
    let categoryButton = UIButton()
    lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TierListCategoryCollectionViewCell.self, forCellWithReuseIdentifier: TierListCategoryCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
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
        setupCategoryButton()
    }
    
    private func addSubviews() {
        [categoryContainer, tableView, categoryButton, categoriesCollectionView].forEach({
            if ($0 == categoryContainer) || ($0 == tableView) {
                addSubview($0)
            } else {
                categoryContainer.addSubview($0)
            }
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            categoryContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 18),
            categoryContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryContainer.heightAnchor.constraint(equalToConstant: Category.Height),
            categoryButton.centerYAnchor.constraint(equalTo: categoryContainer.centerYAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor, constant: 18),
            categoryButton.widthAnchor.constraint(equalToConstant: Category.Height),
            categoryButton.heightAnchor.constraint(equalToConstant: Category.Height),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: categoryContainer.trailingAnchor),
            categoriesCollectionView.centerYAnchor.constraint(equalTo: categoryContainer.centerYAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: Category.Height),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: 3),
            tableView.topAnchor.constraint(equalTo: categoryContainer.bottomAnchor, constant: 9),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupCategoryButton() {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "icon_category")
        categoryButton.configuration = config
    }
}
