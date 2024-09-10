//
//  RestaurantDetailStretchyHeaderView.swift
//  Kustaurant
//
//  Created by 류연수 on 8/21/24.
//

import UIKit

final class RestaurantDetailStretchyHeaderView: UIView {
    
    private let containerView: UIView = .init()
    private let imageView: UIImageView = .init()
    private let dimmedLayer = CAGradientLayer()
    
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var imageViewHeightConstraint: NSLayoutConstraint?
    private var imageViewBottomConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        repositionDimmedLayer()
        containerView.layer.insertSublayer(dimmedLayer, at: UInt32(layer.sublayers?.count ?? 1))
    }
    
    private func setupStyle() {
        containerView.clipsToBounds = false
        imageView.contentMode = .scaleAspectFill
        dimmedLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(1.4).cgColor]
        dimmedLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        dimmedLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        repositionDimmedLayer()
    }
    
    private func repositionDimmedLayer() {
        let dimmedLayerHeight = containerView.bounds.height + 50
        dimmedLayer.frame = CGRect(
            x: containerView.bounds.origin.x,
            y: containerView.bounds.origin.y,
            width: containerView.bounds.width,
            height: dimmedLayerHeight
        )
    }
    
    private func setupLayout() {
        addSubview(containerView, autoLayout: [.widthEqual(to: self, constant: 0)])
        containerView.addSubview(imageView, autoLayout: [.widthEqual(to: containerView, constant: 0)])
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeightConstraint?.isActive = true
        
        imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottomConstraint?.isActive = true
        
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeightConstraint?.isActive = true
    }
    
    func update(image: UIImage) {
        imageView.image = image
    }
    
    func update(contentInset: UIEdgeInsets, contentOffset: CGPoint) {
        containerViewHeightConstraint?.constant = contentInset.top
        let offsetY = -(contentOffset.y + contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottomConstraint?.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeightConstraint?.constant = max(offsetY + contentInset.top, contentInset.top)
        repositionDimmedLayer()
    }
}
