//
//  EvaluationView.swift
//  Kustaurant
//
//  Created by 송우진 on 9/6/24.
//

import UIKit

final class EvaluationView: UIView {
    let tableView: EvaluationTableView = EvaluationTableView()
    let evaluationFloatingView: EvaluationFloatingView = .init(viewType: .evaluation)
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension EvaluationView {
    private func setupUI() {
        backgroundColor = .white
        addSubview(tableView, autoLayout: [.fill(0)])
        addSubview(evaluationFloatingView, autoLayout: [.fillX(0), .bottom(0)])
    }
}