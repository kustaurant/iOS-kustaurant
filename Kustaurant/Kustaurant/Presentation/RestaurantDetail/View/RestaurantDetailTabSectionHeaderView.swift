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
    private let reviewSortingView = ReviewSortingView()
    private var tabBarBottomConstrant: NSLayoutConstraint?
    private var reviewSortingViewHeightConstraint: NSLayoutConstraint?
    
    func update(selectedIndex: Int) -> AnyPublisher<RestaurantDetailTabType?, Never> {
        tabBarView?.removeFromSuperview()
        let tabBarView: KuTabBarView = .init(tabs: ["메뉴", "리뷰"], style: .fill, selectedIndex: selectedIndex)
        self.tabBarView = tabBarView
        
        setupStyle()
        setupLayout()
        
        if selectedIndex == 0 {
            tabBarBottomConstrant?.constant = -26
            reviewSortingViewHeightConstraint?.constant = 0
            reviewSortingView.isHidden = true
        } else {
            tabBarBottomConstrant?.constant = -40
            reviewSortingViewHeightConstraint?.constant = 40
            reviewSortingView.isHidden = false
        }
        
        return tabBarView.actionPublisher.map { action in
            if case let .didSelect(index) = action {
                return RestaurantDetailTabType(rawValue: index)
            }
            return nil
        }.eraseToAnyPublisher()
    }
    
    func popularButtonTapPublisher() -> AnyPublisher<Void, Never> {
        return reviewSortingView.popularButtonTapPublisher().map { [weak self] in
            self?.update(sort: .popular)
        }
        .eraseToAnyPublisher()
    }
    
    func recentButtonTapPublisher() -> AnyPublisher<Void, Never> {
        return reviewSortingView.recentButtonTapPublisher().map { [weak self] in
            self?.update(sort: .recent)
        }
        .eraseToAnyPublisher()
    }
    
    private func update(sort: ReviewSort) {
        reviewSortingView.update(sort: sort)
    }
}

extension RestaurantDetailTabSectionHeaderView {
    
    private func setupStyle() {
        contentView.backgroundColor = .white
    }
    
    private func setupLayout() {
        guard let tabBarView else { return }
        addSubview(tabBarView, autoLayout: [.fillX(0), .top(0)])
        addSubview(reviewSortingView, autoLayout: [.fillX(0), .topNext(to: tabBarView, constant: 8)])
        
        tabBarBottomConstrant = tabBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -26)
        tabBarBottomConstrant?.isActive = true
        reviewSortingViewHeightConstraint = reviewSortingView.heightAnchor.constraint(equalToConstant: 0)
        reviewSortingViewHeightConstraint?.isActive = true
    }
}

fileprivate final class ReviewSortingView: UIView {
    
    private let popularSortButton = UIButton()
    private let recentSortButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(popularSortButton, autoLayout: [.top(4), .leading(20)])
        addSubview(recentSortButton, autoLayout: [.top(4), .leadingNext(to: popularSortButton, constant: 8)])
        
        popularSortButton.autolayout([.width(67), .height(27)])
        recentSortButton.autolayout([.width(67), .height(27)])
        
        setupButton(popularSortButton, title: "인기순")
        setupButton(recentSortButton, title: "최신순")
        popularSortButton.setTitleColor(.Signature.green100, for: .normal)
        popularSortButton.layer.borderColor = UIColor.Signature.green100?.cgColor
        recentSortButton.setTitleColor(.Sementic.gray300, for: .normal)
        recentSortButton.layer.borderColor = UIColor.gray300.cgColor
    }
    
    private func setupButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .Pretendard.regular14
        button.titleLabel?.textAlignment = .center
        
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 13.5
        button.layer.cornerCurve = .continuous
        button.clipsToBounds = true
    }
    
    fileprivate func update(sort: ReviewSort) {
        if sort == .popular {
            popularSortButton.setTitleColor(.Signature.green100, for: .normal)
            popularSortButton.layer.borderColor = UIColor.Signature.green100?.cgColor
            recentSortButton.setTitleColor(.Sementic.gray300, for: .normal)
            recentSortButton.layer.borderColor = UIColor.gray300.cgColor
        } else {
            recentSortButton.setTitleColor(.Signature.green100, for: .normal)
            recentSortButton.layer.borderColor = UIColor.Signature.green100?.cgColor
            popularSortButton.setTitleColor(.Sementic.gray300, for: .normal)
            popularSortButton.layer.borderColor = UIColor.gray300.cgColor
        }
    }
    
    fileprivate func popularButtonTapPublisher() -> AnyPublisher<Void, Never> {
        return popularSortButton.tapPublisher()
    }
    
    fileprivate func recentButtonTapPublisher() -> AnyPublisher<Void, Never> {
        return recentSortButton.tapPublisher()
    }
}
