//
//  RestaurantDetailReviewCell.swift
//  Kustaurant
//
//  Created by 류연수 on 8/4/24.
//

import UIKit

extension RestaurantDetailReviewCell {
    
    struct Review {
        let profileImageName: String
        let nickname: String
        let time: String
        let photoImageName: String
        let review: String
        let rating: Double
        let isComment: Bool
    }
}

final class RestaurantDetailReviewCell: UITableViewCell {
    
    private let starsRatingStackView: StarsRatingStackView = .init()
    private let reviewView: RestaurantDetailReviewView = .init()
    private let lineView: UIView = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(review: Review, hasComments: Bool) {
        starsRatingStackView.update(rating: review.rating)
        reviewView.update(with: review)
        lineView.isHidden = !hasComments
    }
    
    private func setupStyle() { 
        lineView.backgroundColor = .gray100
    }
    
    private func setupLayout() {
        let stackView: UIStackView = .init(arrangedSubviews: [starsRatingStackView, reviewView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        contentView.addSubview(stackView, autoLayout: [.fillX(20), .top(22)])
        contentView.addSubview(lineView, autoLayout: [.fillX(20), .topNext(to: stackView, constant: 22), .bottom(0), .height(2)])
    }
}

extension RestaurantDetailReviewCell {
    
    final class StarsRatingStackView: UIStackView {
        private let starsStackView: StarsStackView = .init()
        private let label: UILabel = .init()
        
        init() {
            super.init(arrangedSubviews: [starsStackView, label])
            
            setupStyle()
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func update(rating: Double) {
            starsStackView.update(rating: rating)
            label.text = "\(rating)"
        }
        
        private func setupStyle() {
            axis = .horizontal
            distribution = .fillProportionally
            alignment = .center
            spacing = 7
        }
    }
    
    final class StarsStackView: UIStackView {
        
        private let starImageViews: [UIImageView] = {
            (0..<5).map { _ in
                    .init(image: .init(named: "star_empty"))
            }
        }()
        
        init() {
            super.init(arrangedSubviews: starImageViews)
            
            setupStyle()
            setupLayout()
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func update(rating: Double) {
            let count = Int(rating)
            (0..<count).forEach { index in
                starImageViews[safe: index]?.image = .init(named: "start_fill")
            }
            if rating > Double(count) {
                starImageViews[safe: count + 1]?.image = .init(named: "star_half_fill")
            }
        }
        
        private func setupStyle() {
            axis = .horizontal
            distribution = .fillEqually
            alignment = .center
        }
        
        private func setupLayout() {
            starImageViews.forEach {
                $0.autolayout([.width(26), .height(26)])
            }
        }
    }
}
