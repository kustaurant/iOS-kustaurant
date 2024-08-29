//
//  MyPageUserProfileHeaderView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/28/24.
//

import UIKit

final class MyPageUserProfileView: UIView {
    
    private let containerView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    private let greenView: UIView = {
        let view = UIView()
        view.backgroundColor = .Signature.green200
        return view
    }()
    
    private let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_person")
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 39
        iv.clipsToBounds = true
        return iv
    }()
    
    let profileButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .Pretendard.semiBold20
        return button
    }()
    
    private let myActivityShadowContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .Signature.green100
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let myActivityContainerView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.layer.cornerRadius = 16
        sv.clipsToBounds = true
        return sv
    }()
    
    private let myEvaluationView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let myEvaluationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 평가"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .Pretendard.semiBold14
        return label
    }()
    
    let myEvaluationCountLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .white
        label.font = .Pretendard.bold20
        label.textAlignment = .center
        return label
    }()
    
    private let myPostsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let myPostsLabel: UILabel = {
        let label = UILabel()
        label.text = "내 게시글"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .Pretendard.semiBold14
        return label
    }()
    
    let myPostCountLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .Pretendard.bold20
        return label
    }()
    
    private let activityDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
        setupMyActivityContainerView()
        setupProfileImageView()
        setupProfileButton()
        setupMyActivityLabels()
        setupActivityDivider()
    }
        
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageUserProfileView {
    
    private func setupContainerView() {
        addSubview(containerView, autoLayout: [.fill(0)])
        containerView.addArrangedSubview(greenView, proportion: 0.9)
        containerView.addArrangedSubview(whiteView, proportion: 0.1)
    }
    
    private func setupMyActivityContainerView() {
        addSubview(myActivityShadowContainerView, autoLayout: [.fillX(20), .topNext(to: greenView, constant: -48), .height(78)])
        myActivityShadowContainerView.addSubview(myActivityContainerView, autoLayout: [.fill(0)])
        myActivityContainerView.addArrangedSubview(myEvaluationView)
        myActivityContainerView.addArrangedSubview(myPostsView)
    }
    
    private func setupProfileImageView() {
        greenView.addSubview(profileImageView, autoLayout: [.centerX(0), .centerY(0), .width(77), .height(77)])
    }
    
    private func setupProfileButton() {
        greenView.addSubview(profileButton, autoLayout: [.topNext(to: profileImageView, constant: 12), .centerX(0)])
    }
    
    private func setupMyActivityLabels() {
        myEvaluationView.addSubview(myEvaluationTitleLabel, autoLayout: [.fillX(0), .centerY(-8)])
        myEvaluationView.addSubview(myEvaluationCountLabel, autoLayout: [.fillX(0), .centerY(8)])
        myPostsView.addSubview(myPostsLabel, autoLayout: [.fillX(0), .centerY(-8)])
        myPostsView.addSubview(myPostCountLabel, autoLayout: [.fillX(0), .centerY(8)])
    }
    
        
    private func setupActivityDivider() {
        myActivityShadowContainerView.addSubview(activityDividerView, autoLayout: [.width(1), .centerX(0), .fillY(16)])
    }
}
