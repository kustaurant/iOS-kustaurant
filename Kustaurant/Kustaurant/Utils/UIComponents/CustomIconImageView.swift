//
//  CustomIconImageView.swift
//  Kustaurant
//
//  Created by 송우진 on 7/24/24.
//

import UIKit

final class CustomIconImageView: UIView {
    private let imageView = UIImageView()
    
    enum CustomIconImageType: String {
        case check = "check"
        case favorite = "favorite"
    }
    
    // MARK: - Initialization
    init(
        type: CustomIconImageType,
        size: CGSize
    ) {
        super.init(frame: .zero)
        setupView(type: type, size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomIconImageView {
    private func setupView(
        type: CustomIconImageType,
        size: CGSize
    ) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon_\(type.rawValue)")
        
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: size.width),
            imageView.heightAnchor.constraint(equalToConstant: size.height),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func updateSize(to size: CGSize) {
        for constraint in imageView.constraints {
            if constraint.firstAttribute == .width {
                constraint.constant = size.width
            } else if constraint.firstAttribute == .height {
                constraint.constant = size.height
            }
        }
    }
}
