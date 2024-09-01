//
//  NoticeBoardView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/30/24.
//

import UIKit
import WebKit

class NoticeBoardView: UIView {
    
    let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NoticeBoardView {
    
    private func setupUI() {
        addSubview(tableView, autoLayout: [.fill(0)])
    }
}
