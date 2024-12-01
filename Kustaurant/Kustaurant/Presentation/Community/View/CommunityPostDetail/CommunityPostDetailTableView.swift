//
//  CommunityPostDetailTableView.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import UIKit

final class CommunityPostDetailTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .plain)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        separatorStyle = .none
        rowHeight = UITableView.automaticDimension
        sectionHeaderTopPadding = 0
        
        registerCell(ofType: CommunityPostDetailBodyCell.self)
        registerCell(ofType: CommunityPostDetailCommentCell.self)
        registerCell(ofType: CommunityPostDetailReplyCell.self)
    }
}
