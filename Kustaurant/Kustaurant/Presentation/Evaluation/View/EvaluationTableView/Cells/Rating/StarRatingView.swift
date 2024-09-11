//
//  StarRatingView.swift
//  Kustaurant
//
//  Created by 송우진 on 9/11/24.
//

import UIKit

final class StarRatingView: UIView {
    private var starImageViews: [UIImageView] = []
    private let filledStarImage = UIImage(named: "icon_star_fill")
    private let halfStarImage = UIImage(named: "icon_star_half_fill")
    private let emptyStarImage = UIImage(named: "icon_star")
    
    var ratingChanged: ((Float) -> Void)?
    
    // 현재 별점
    var rating: Float = 5 {
        didSet {
            updateStarRating()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

// MARK: - Actions
extension StarRatingView {
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        updateRating(at: location)
    }

    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        updateRating(at: location)
    }
    
    private func updateRating(at location: CGPoint) {
        let starWidth = bounds.width / 5
        let position = location.x / starWidth
        var newRating = Float(position)
        
        // 최소값을 0.5로 제한
        if newRating < 0.5 {
            newRating = 0.5
        }
        
        // 0.5 단위로 반올림
        rating = round(newRating * 2) / 2
        
        ratingChanged?(rating)
    }
}

extension StarRatingView {
    private func setupView() {
        for _ in 0..<5 {
            let imageView = UIImageView()
            starImageViews.append(imageView)
            addSubview(imageView)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        addGestureRecognizer(tapGesture)
        
        setupConstraints()
        updateStarRating()
    }

    private func updateStarRating() {
        for (index, imageView) in starImageViews.enumerated() {
            let starValue = Float(index) + 1
            
            if rating >= starValue {
                imageView.image = filledStarImage
            } else if rating >= starValue - 0.5 {
                imageView.image = halfStarImage
            } else {
                imageView.image = emptyStarImage
            }
        }
    }

    private func setupConstraints() {
        for (index, imageView) in starImageViews.enumerated() {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            if index == 0 {
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            } else {
                let previousImageView = starImageViews[index - 1]
                imageView.leadingAnchor.constraint(equalTo: previousImageView.trailingAnchor, constant: 2).isActive = true
            }
        }
    }
}
