//
//  SplashView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/6/24.
//

import UIKit

final class SplashView: UIView {
    
    private var containerView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        return sv
    }()
    
    private var kuLogoView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_ku")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private var kuTextImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "text_ku")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private var kuLabelView: UILabel = {
        let label = UILabel()
        label.text = "건대생을 위한 맛집 리스트"
        label.font = .Pretendard.medium20
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("fail to initialze SplashView")
    }
}

extension SplashView {
    
    private func setupUI() {
        backgroundColor = .Signature.green100
        addSubview(containerView, autoLayout: [.center(0)])
        containerView.addArrangedSubview(kuLogoView)
        containerView.addArrangedSubview(kuTextImageView)
        containerView.addArrangedSubview(kuLabelView)
    }
}
