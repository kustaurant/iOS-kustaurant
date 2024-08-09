//
//  DrawView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/9/24.
//

import UIKit

final class DrawView: UIView {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "건국대 주변 맛집을 랜덤으로 뽑아보아요!"
        label.textColor = .Sementic.gray400
        label.font = .Pretendard.regular13
        return label
    }()
    
    var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return cv
    }()
    
    private let submitButton: KuSubmitButton = {
        let button = KuSubmitButton()
        button.buttonTitle = "랜덤 뽑기"
        button.buttonState = .on
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DrawView {
    
    private func setupUI() {
        addSubview(headerLabel, autoLayout: [.topSafeArea(constant: 20), .fillX(0)])
        addSubview(collectionView, autoLayout: [.topNext(to: headerLabel, constant: 13), .fillX(0)])
        addSubview(submitButton,
                   autoLayout: [
                    .topNext(to: collectionView, constant: 28),
                    .fillX(20),
                    .height(52),
                    .bottomSafeArea(constant: 28)
                    ])
    }
}
