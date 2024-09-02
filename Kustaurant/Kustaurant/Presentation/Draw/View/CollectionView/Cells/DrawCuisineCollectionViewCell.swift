//
//  DrawCuisineCollectionViewCell.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/9/24.
//

import UIKit

class DrawCuisineCollectionViewCell: UICollectionViewCell, ReusableCell{
    
    static var reuseIdentifier: String = String(describing: DrawCuisineCollectionViewCell.self)
    
    private var highlight: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .Sementic.gray800
        label.font = .Pretendard.medium11
        label.textAlignment = .center
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

extension DrawCuisineCollectionViewCell {
    
    private func setupUI() {
        contentView.backgroundColor = .Sementic.gray50
        contentView.layer.cornerRadius = 15
        addSubview(imageView, autoLayout: [.top(7), .fillX(6)])
        addSubview(label, autoLayout: [.topNext(to: imageView, constant: 0), .fillX(0), .bottom(7.5)])
    }
    
    func configure(with selectable: SelectableCuisine) {
        imageView.image = UIImage(named: selectable.cuisine.iconName)?.withRenderingMode(.alwaysOriginal)
        label.text = selectable.cuisine.rawValue
        highlight = selectable.isSelected
    }
    
    private func updateUI() {
        contentView.layer.borderColor = highlight ? UIColor.Signature.green100?.cgColor : UIColor.clear.cgColor
        contentView.layer.borderWidth = 1
    }
}
