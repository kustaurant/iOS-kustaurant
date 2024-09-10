//
//  RestaurantDetailTabSectionHeaderView.swift
//  Kustaurant
//
//  Created by 류연수 on 8/12/24.
//

import UIKit
import Combine

final class RestaurantDetailTabSectionHeaderView: UITableViewHeaderFooterView {
    
    private var tabBarView: KuTabBarView?
    
    func update(selectedIndex: Int) -> AnyPublisher<RestaurantDetailTabType?, Never> {
        tabBarView?.removeFromSuperview()
        let tabBarView: KuTabBarView = .init(tabs: ["메뉴", "리뷰"], style: .fill, selectedIndex: selectedIndex)
        self.tabBarView = tabBarView
        
        setupStyle()
        setupLayout()
        
        return tabBarView.actionPublisher.map { action in
            if case let .didSelect(index) = action {
                return RestaurantDetailTabType(rawValue: index)
            }
            return  nil
        }.eraseToAnyPublisher()
    }
}

extension RestaurantDetailTabSectionHeaderView {
    
    private func setupStyle() {
        backgroundColor = .white
        backgroundView = .none
        backgroundConfiguration = .clear()
    }
    
    private func setupLayout() {
        guard let tabBarView else { return }
        addSubview(tabBarView, autoLayout: [.fillX(0), .top(0), .bottom(26)])
    }
}
