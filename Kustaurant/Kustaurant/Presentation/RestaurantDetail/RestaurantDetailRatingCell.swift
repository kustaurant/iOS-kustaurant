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
    
    func update(count: Int, score: Double) {
        ratingCountView.update(title: "평가수", rating: "\(count)개")
        ratingScoreView.update(title: "평점", rating: "\(score)")
    }
    
    private func setupStyle() { }
    
    private func setupLayout() {
        let stackView: UIStackView = .init(arrangedSubviews: [ratingCountView, lineView, ratingScoreView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        contentView.addSubview(stackView, autoLayout: [.fill(0)])
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
    
    private func setupStyle() { }
    
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
        autolayout([.width(34)])
    }
}
