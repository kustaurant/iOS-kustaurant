//
//  RestaurantDetailTabSectionHeaderView.swift
//  Kustaurant
//
//  Created by 류연수 on 8/12/24.
//

import UIKit
import Combine

final class RestaurantDetailTabSectionHeaderView: UITableViewHeaderFooterView {
    
    private let tabBarView: KuTabBarView = .init(tabs: ["메뉴", "리뷰"], style: .fill)
    
    var actionPublisher: AnyPublisher<RestaurantDetailTabType?, Never> {
        tabBarView.actionPublisher.map { action in
            if case let .didSelect(index) = action {
                return RestaurantDetailTabType(rawValue: index)
            }
            return  nil
        }.eraseToAnyPublisher()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RestaurantDetailTabSectionHeaderView {
    
    private func setupStyle() { }
    
    private func setupLayout() {
        addSubview(tabBarView, autoLayout: [.fill(0)])
    }
}
