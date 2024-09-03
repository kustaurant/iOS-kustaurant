//
//  RestaurantDetailRatingCell.swift
//  Kustaurant
//
//  Created by 류연수 on 7/31/24.
//

import UIKit

final class RestaurantDetailRatingCell: UITableViewCell {
    private let ratingCountView: RatingView = .init()
    private let lineView: LineView = .init()
    private let ratingScoreView: RatingView = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: RestaurantDetailCellItem) {
        guard let item = item as? RestaurantDetailRating else { return }
        
        ratingCountView.update(title: "평가수", rating: "\(item.count)개")
        ratingScoreView.update(title: "평점", rating: "\(item.score ?? 0)")
    }
    
    private func setupStyle() {
        selectionStyle = .none
    }
    
    private func setupLayout() {
        let stackView: UIStackView = .init(arrangedSubviews: [ratingCountView, lineView, ratingScoreView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        contentView.addSubview(stackView, autoLayout: [.fill(0)])
        [ratingCountView, ratingScoreView].forEach {
            $0.autolayout([.width(UIScreen.main.bounds.width / 2 - 1)])
        }
    }
}

fileprivate final class RatingView: UIView {
    private let titleLabel: UILabel = .init()
    private let ratingLabel: UILabel = .init()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(title: String, rating: String) {
        self.titleLabel.text = title
        self.ratingLabel.text = rating
    }
    
    private func setupStyle() {
        titleLabel.font = .Pretendard.regular12
        titleLabel.textColor = .Sementic.gray800
        ratingLabel.font = .Pretendard.bold18
        ratingLabel.textColor = .Sementic.gray800
    }
    
    private func setupLayout() {
        let stackView: UIStackView = .init(arrangedSubviews: [titleLabel, ratingLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .center
        addSubview(stackView, autoLayout: [.fill(0)])
    }
}

fileprivate final class LineView: UIView {
    private let line: UIView = .init()
    
    convenience init() {
        self.init(frame: .zero)
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
        line.backgroundColor = .gray
        line.layer.cornerRadius = 0.5
        line.layer.cornerCurve = .continuous
    }
    
    private func setupLayout() {
        addSubview(line, autoLayout: [.width(1), .height(32), .centerX(0), .fillY(0)])
        autolayout([.width(1)])
    }
}
