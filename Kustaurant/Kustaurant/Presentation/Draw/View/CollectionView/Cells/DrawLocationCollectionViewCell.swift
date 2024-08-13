//
//  DrawLocationCollectionViewCell.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/9/24.
//

import UIKit

final class DrawLocationCollectionViewCell: UICollectionViewCell, ReusableCell {
    static var reuseIdentifier: String = String(describing: DrawLocationCollectionViewCell.self)
    static var horizontalPadding: CGFloat = 16
    private var label = PaddedLabel()
    
    private var highlight: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DrawLocationCollectionViewCell {
    private func setupUI() {
        contentView.layer.borderWidth = 0.7
        contentView.layer.cornerRadius = 16
        contentView.layer.borderColor = UIColor.categoryOff.cgColor
        contentView.backgroundColor = .clear
        contentView.addSubview(label, autoLayout: [.centerX(0), .centerY(0)])
        label.textColor = .categoryOff
        label.font = .Pretendard.regular14
        label.textAlignment = .center
        label.textInsets = UIEdgeInsets(top: 0, left: Self.horizontalPadding, bottom: 0, right: Self.horizontalPadding)
    }
    
    private func updateUI() {
        contentView.layer.borderColor = highlight ? UIColor.Signature.green100?.cgColor : UIColor.categoryOff.cgColor
        contentView.backgroundColor = highlight ? .categoryOn : .clear
        label.textColor = highlight ? .Signature.green100 : .categoryOff
    }
    
    func configure(with selectable: SelectableLocation) {
        label.text = selectable.location.category.displayName
        highlight = selectable.isSelected
    }
}

extension DrawLocationCollectionViewCell {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let labelSize = label.sizeThatFits(CGSize(width: size.width - 2 * DrawLocationCollectionViewCell.horizontalPadding, height: CGFloat.greatestFiniteMagnitude))
        let width = labelSize.width + 2 * DrawLocationCollectionViewCell.horizontalPadding
        let height = labelSize.height + 2 * 8
        return CGSize(width: width, height: height)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.size.width, height: CGFloat.greatestFiniteMagnitude)
        let autoLayoutSize = sizeThatFits(targetSize)
        
        var newFrame = layoutAttributes.frame
        newFrame.size = autoLayoutSize
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}
