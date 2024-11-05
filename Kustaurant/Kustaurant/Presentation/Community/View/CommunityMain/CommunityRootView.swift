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
    private(set) var writeButton: KuSubmitButton = .init()
    
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
        writeButton.buttonState = .on
        writeButton.size = .custom(.Pretendard.semiBold15, 10)
        writeButton.buttonTitle = "글 쓰기"
        writeButton.imagePlacement = .trailing
        writeButton.image = UIImage(named: "icon_write")
        writeButton.layer.shadowColor = UIColor.black.cgColor
        writeButton.layer.shadowOpacity = 0.25
        writeButton.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        writeButton.layer.shadowRadius = 3
        writeButton.layer.masksToBounds = false
    }
    
    private func setupLayout() {
        addSubview(communityFilterView, autoLayout: [.topSafeArea(constant: 0), .fillX(0), .height(67)])
        addSubview(postsCollectionView, autoLayout: [.topNext(to: communityFilterView, constant: 0), .fillX(0), .bottom(0)])
        addSubview(writeButton, autoLayout: [.bottomSafeArea(constant: 22), .trailing(20), .height(37), .width(104)])
    }
}
