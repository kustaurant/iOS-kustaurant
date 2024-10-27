//
//  RestaurantDetailMenuCell.swift
//  Kustaurant
//
//  Created by 류연수 on 8/1/24.
//

import UIKit

final class RestaurantDetailMenuCell: UITableViewCell {
    
    private let menuImageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let priceLabel: UILabel = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: RestaurantDetailCellItem) {
        guard let item = item as? RestaurantDetailMenu else { return }
        updateMenuImageView(item.imageURLString)
        titleLabel.text = item.title
        priceLabel.text = item.price
    }
}

extension RestaurantDetailMenuCell {
    
    private func setupStyle() {
        selectionStyle = .none
        
        menuImageView.layer.cornerCurve = .continuous
        menuImageView.layer.cornerRadius = 11
        menuImageView.contentMode = .scaleToFill
        menuImageView.clipsToBounds = true
        
        titleLabel.font = .Pretendard.regular14
        titleLabel.textColor = .Sementic.gray600
        
        priceLabel.font = .Pretendard.regular14
        priceLabel.textColor = .Sementic.gray800
    }
    
    private func setupLayout() {
        let labelStackView: UIStackView = .init(arrangedSubviews: [titleLabel, priceLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 6
        labelStackView.distribution = .fillProportionally
        labelStackView.alignment = .leading
        
        let stackView: UIStackView = .init(arrangedSubviews: [menuImageView, labelStackView])
        stackView.axis = .horizontal
        stackView.spacing = 28
        stackView.distribution = .fill
        stackView.alignment = .center
        
        contentView.addSubview(stackView, autoLayout: [.fillX(20), .top(0), .bottom(13)])
        menuImageView.autolayout([.width(94), .height(77)])
    }
    
    private func updateMenuImageView(_ urlString: String?) {
        let defaultMenuImage = UIImage(named: "icon_menu_default")
        Task {
            guard let urlString,
                  let url = URL(string: urlString)
            else {
                await MainActor.run {
                    menuImageView.image = defaultMenuImage
                }
                return
            }
            
            let image = await ImageCacheManager.shared.loadImage(
                from: url,
                targetSize: CGSize(width: 94, height: 94),
                defaultImage: defaultMenuImage
            )
            await MainActor.run {
                menuImageView.image = image
            }
        }
    }
}
