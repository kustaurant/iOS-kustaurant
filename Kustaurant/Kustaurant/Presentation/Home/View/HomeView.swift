//
//  HomeView.swift
//  Kustaurant
//
//  Created by 송우진 on 7/17/24.
//

import UIKit

final class HomeView: UIView {
    lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(HomeMainCollectionViewCell.self, forCellWithReuseIdentifier: HomeMainCollectionViewCell.reuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Default")
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

extension HomeView {
    private func setupUI() {
        addSubviews()
        setupConstraint()
    }
    
    private func addSubviews() {
        [mainCollectionView].forEach({ 
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: topAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
