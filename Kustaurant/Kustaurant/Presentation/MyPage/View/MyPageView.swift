//
//  MyPageView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/20/24.
//

import UIKit

class MyPageView: UIView {
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .Sementic.gray75
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonTableView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageView {
    
    private func setupButtonTableView() {
        addSubview(tableView, autoLayout: [.fill(0)])
    }
}
