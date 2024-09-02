//
//  RestaurantDetailReviewView.swift
//  Kustaurant
//
//  Created by 류연수 on 8/10/24.
//

import UIKit

final class RestaurantDetailReviewView: UIView {
    
    private let profileImageView: UIImageView = .init()
    private let nicknameLabel: UILabel = .init()
    private let barView: UIView = .init()
    private let timeLabel: UILabel = .init()
    private let menuEllipsisButton: UIButton = .init()
    
    private let photoImageView: UIImageView = .init()
    private let reviewLabel: UILabel = .init()
    
    private let goodIconButton: UIButton = .init()
    private let badIconButton: UIButton = .init()
    private let commentsIconButton: UIButton = .init()
    
    init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with model: RestaurantDetailReviewCell.Review) {
        profileImageView.image = UIImage(named: model.profileImageName)
        nicknameLabel.text = model.nickname
        barView.backgroundColor = .gray100
        timeLabel.text = model.time
        photoImageView.image = UIImage(named: model.photoImageName)
        reviewLabel.text = model.review
        commentsIconButton.isHidden = model.isComment
    }
    
    private func setupStyle() {
        nicknameLabel.font = .boldSystemFont(ofSize: 14)
        nicknameLabel.textColor = .black
        
        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.textColor = .gray
        
        photoImageView.contentMode = .scaleAspectFill
        
        reviewLabel.font = .systemFont(ofSize: 14)
        reviewLabel.textColor = .black
        reviewLabel.numberOfLines = 0
        
        goodIconButton.setImage(UIImage(named: "thumbs_up"), for: .normal)
        badIconButton.setImage(UIImage(named: "thumbs_down"), for: .normal)
        commentsIconButton.setImage(UIImage(named: "comments"), for: .normal)
        
        menuEllipsisButton.setImage(UIImage(named: "ellipsis"), for: .normal)
    }
    
    private func setupLayout() {
        let topStackView = UIStackView(arrangedSubviews: [profileImageView, nicknameLabel, barView, timeLabel, menuEllipsisButton])
        topStackView.axis = .horizontal
        topStackView.alignment = .center
        topStackView.spacing = 8
        
        profileImageView.autolayout([.height(24), .width(24)])
        barView.autolayout([.width(1), .height(14)])
        menuEllipsisButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let interactionStackView = UIStackView(arrangedSubviews: [goodIconButton, badIconButton, commentsIconButton])
        interactionStackView.axis = .horizontal
        interactionStackView.alignment = .center
        interactionStackView.spacing = 12
        
        let mainStackView = UIStackView(arrangedSubviews: [topStackView, photoImageView, reviewLabel, interactionStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 11
        
        photoImageView.autolayout([.height(207), .width(207)])
        addSubview(mainStackView, autoLayout: [.fill(0)])
    }
}
