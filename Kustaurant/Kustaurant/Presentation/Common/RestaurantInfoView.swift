//
//  RestaurantInfoView.swift
//  Kustaurant
//
//  Created by 송우진 on 9/8/24.
//

import UIKit

final class InfoView: UIView {
    
    private let iconImageView: UIImageView = .init()
    private let label: UILabel = .init()
    
    var image: UIImage? {
        didSet {
            iconImageView.image = image
        }
    }
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    convenience init(image: UIImage?, text: String?) {
        self.init(frame: .zero)
        
        self.image = image
        self.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
        label.font = .Pretendard.medium15
        label.textColor = .Sementic.gray300
        iconImageView.contentMode = .scaleAspectFit
    }
    
    private func setupLayout() {
        addSubview(iconImageView, autoLayout: [.centerY(0), .leading(0), .width(15), .height(15)])
        addSubview(label, autoLayout: [.leadingNext(to: iconImageView, constant: 6), .top(0), .bottom(0), .trailing(0)])
    }
}
