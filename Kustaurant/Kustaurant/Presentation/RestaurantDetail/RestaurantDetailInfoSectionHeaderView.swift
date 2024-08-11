//
//  RestaurantDetailInfoSectionHeaderView.swift
//  Kustaurant
//
//  Created by 류연수 on 7/31/24.
//

import UIKit

final class RestaurantDetailInfoSectionHeaderView: UITableViewHeaderFooterView {
    
    private let label: UILabel = .init()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(text: String) {
        label.text = text
    }
}

extension RestaurantDetailInfoSectionHeaderView {
    
    private func setupStyle() { }
    
    private func setupLayout() {
        addSubview(label, autoLayout: [.fillX(20), .fillY(0)])
    }
}
