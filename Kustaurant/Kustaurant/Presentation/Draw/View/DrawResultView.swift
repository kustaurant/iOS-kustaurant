//
//  DrawResultView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/10/24.
//

import UIKit

class DrawResultView: UIView {
    
    private let containerView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    private let rouletteContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let rouletteScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isPagingEnabled = false
        view.isScrollEnabled = false
        return view
    }()
    
    let drawedRestaurantImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.Signature.green100?.cgColor
        iv.layer.borderWidth = 1
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOpacity = 0.4
        iv.layer.shadowOffset = CGSize(width: 0, height: 4)
        iv.layer.shadowRadius = 4
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.alpha = 0
        return iv
    }()
    
    let rouletteStackView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        return sv
    }()
    
    let labelContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard.regular14
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard.bold20
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let ratingsView: KuStarRatingView = {
        let view = KuStarRatingView()
        return view
    }()
    
    let partinerShipLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard.regular18
        label.textColor = .gray700
        label.textAlignment = .center
        return label
    }()
    
    private let buttonContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let resetCategoryButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.Signature.green100?.cgColor
        button.backgroundColor = .white
        button.setTitle("카테고리 재설정", for: .normal)
        button.setTitleColor(.Signature.green100, for: .normal)
        button.titleLabel?.font = .Pretendard.semiBold16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = false
        return button
    }()
    
    let redrawButton: KuSubmitButton = {
        let button = KuSubmitButton()
        let buttonImage = UIImage(named: "icon_arrow_counterclockwise")
        button.buttonTitle = "다시 뽑기"
        button.buttonState = .on
        button.size = .medium
        button.image = buttonImage
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupContainerView()
        setupRouletteView()
        setupLabelsView()
        setupButtonsView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DrawResultView {
    
    private func setupContainerView() {
        addSubview(containerView, autoLayout: [.fillX(0), .topSafeArea(constant: 40), .bottomSafeArea(constant: 0)])
        containerView.addArrangedSubview(rouletteContainerView, proportion: 0.5)
        containerView.addArrangedSubview(labelContainerView, proportion: 0.3)
        containerView.addArrangedSubview(buttonContainerView, proportion: 0.2)
    }
    
    private func setupRouletteView() {
        rouletteContainerView.addSubview(rouletteScrollView, autoLayout: [.fillX(0), .fillY(16)])
        rouletteContainerView.addSubview(drawedRestaurantImageView, autoLayout: [.fillX(32), .fillY(0)])
        rouletteScrollView.addSubview(rouletteStackView, autoLayout: [.fillX(0), .fillY(24)])
        rouletteStackView.heightAnchor.constraint(equalTo: rouletteScrollView.heightAnchor).isActive = true
        for _ in 0..<DrawResultViewHandler.rouletteCount {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            rouletteStackView.addArrangedSubview(iv)
            iv.widthAnchor.constraint(equalTo: rouletteScrollView.widthAnchor).isActive = true
        }
    }
    
    private func setupLabelsView() {
        labelContainerView.addSubview(categoryLabel, autoLayout: [.top(26), .fillX(0)])
        labelContainerView.addSubview(restaurantNameLabel, autoLayout: [.topNext(to: categoryLabel, constant: 8), .fillX(0)])
        labelContainerView.addSubview(ratingsView, autoLayout: [.topNext(to: restaurantNameLabel, constant: 8), .centerX(0)])
        labelContainerView.addSubview(partinerShipLabel, autoLayout: [.topNext(to: ratingsView, constant: 12), .fillX(0)])
    }
    
    private func setupButtonsView() {
        buttonContainerView.addSubview(resetCategoryButton, autoLayout: [.top(20), .leading(44), .height(44)])
        buttonContainerView.addSubview(redrawButton, autoLayout: [.top(20), .trailing(44), .height(44), .leadingNext(to: resetCategoryButton, constant: 12)])
        redrawButton.widthAnchor.constraint(equalTo: resetCategoryButton.widthAnchor).isActive = true
    }
}
