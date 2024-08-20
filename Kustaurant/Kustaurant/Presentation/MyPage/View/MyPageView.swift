//
//  MyPageView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/20/24.
//

import UIKit

class MyPageView: UIView {
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .Pretendard.regular14
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageView {
    
    private func setupUI() {
        addSubview(logoutButton, autoLayout: [.center(0), .width(200), .height(40)])
    }
}
