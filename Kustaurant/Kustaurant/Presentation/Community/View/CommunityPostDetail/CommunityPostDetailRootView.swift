//
//  CommunityPostDetailRootView.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import UIKit

final class CommunityPostDetailRootView: UIView {
    private(set) var tableView: CommunityPostDetailTableView = .init()
    private(set) var commentAccessoryView: CommentAccessoryView = .init()
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
        addSubview(commentAccessoryView, autoLayout: [.fillX(0), .height(68), .bottomKeyboard(0)])
    }
}
