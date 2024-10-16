//
//  CommunityRootView.swift
//  Kustaurant
//
//  Created by 송우진 on 10/14/24.
//

import UIKit

final class CommunityRootView: UIView {
    private(set) var communityFilterView: CommunityFilterView = .init()
    private(set) var postsCollectionView: CommunityPostsCollectionView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFilterView(
        category: CommunityPostCategory? = nil,
        sortType: CommunityPostSortType? = nil
    ) {
        communityFilterView.update(category: category, sortType: sortType)
    }
}

extension CommunityRootView {
    private func setupStyle() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        addSubview(communityFilterView, autoLayout: [.topSafeArea(constant: 0), .fillX(0), .height(67)])
        addSubview(postsCollectionView, autoLayout: [.topNext(to: communityFilterView, constant: 0), .fillX(0), .bottom(0)])
    }
}
