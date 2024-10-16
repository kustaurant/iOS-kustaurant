//
//  CommunityRootView.swift
//  Kustaurant
//
//  Created by 송우진 on 10/14/24.
//

import UIKit

final class CommunityRootView: UIView {
    private(set) var postsCollectionView: CommunityPostsCollectionView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommunityRootView {
    private func setupStyle() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        addSubview(postsCollectionView, autoLayout: [.fill(0)])
    }
}
