//
//  OnboardingCollectionViewCell.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/7/24.
//

import UIKit

final class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String = String(describing: OnboardingCollectionViewCell.self)
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = .Pretendard.bold20
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OnboardingCollectionViewCell {
    
    private func setupUI() {
        addSubview(imageView, autoLayout: [.top(0), .leading(0), .trailing(0)])
        addSubview(
            label,
            autoLayout: [
                .topNext(to: imageView, constant: 12),
                .leading(66),
                .trailing(66),
                .bottom(0)
            ])
    }
    
    func bind(content: OnboardingContent) {
        imageView.image = content.image
        label.setAttributedText(text: content.text, highlightedText: content.highlightedText, highlightColor: .Signature.green100 ?? .black)
    }
}
