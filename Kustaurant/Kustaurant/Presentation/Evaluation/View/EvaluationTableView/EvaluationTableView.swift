//
//  EvaluationTableView.swift
//  Kustaurant
//
//  Created by 송우진 on 9/6/24.
//

import UIKit

final class EvaluationTableView: UITableView {
    init() {
        super.init(frame: .zero, style: .plain)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        sectionFooterHeight = 0
        sectionHeaderTopPadding = 0
        tableHeaderView = nil
        tableFooterView = nil
        
        registerCell(ofType: EvaluationTitleCell.self)
        registerCell(ofType: EvaluationKeywordCell.self)
        registerCell(ofType: EvaluationRatingCell.self)
        registerCell(ofType: EvaluationReviewCell.self)
    }
}
