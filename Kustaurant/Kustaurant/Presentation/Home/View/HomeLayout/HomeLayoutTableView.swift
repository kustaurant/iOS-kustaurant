//
//  HomeLayoutTableView.swift
//  Kustaurant
//
//  Created by 송우진 on 8/4/24.
//

import UIKit

final class HomeLayoutTableView: UITableView {
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
        
        registerCell(ofType: HomeCategoriesSection.self, withReuseIdentifier: HomeCategoriesSection.reuseIdentifier)
        registerCell(ofType: HomeRestaurantsSection.self, withReuseIdentifier: HomeRestaurantsSection.reuseIdentifier)
        registerCell(ofType: UITableViewCell.self, withReuseIdentifier: "Default")
    }
}
