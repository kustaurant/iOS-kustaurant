//
//  OnboardingView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/7/24.
//

import UIKit

struct OnboardingContent {
    let image: UIImage
    let text: String
    let highlightedText: String
    
    private init(image: UIImage, text: String, highlightedText: String) {
        self.image = image
        self.text = text
        self.highlightedText = highlightedText
    }
    
    static func all() -> [OnboardingContent] {
        [
            OnboardingContent(image: UIImage(named: "img_onboarding_1")!, text: "건대생들이 선정한 건대맛집,\n티어 시스템으로 빠르게 확인!", highlightedText: "티어 시스템"),
            OnboardingContent(image: UIImage(named: "img_onboarding_2")!, text: "신입생도 파악하기 쉽게,\n건대생 지도를 통한 맛집 확인!", highlightedText: "건대생 지도"),
            OnboardingContent(image: UIImage(named: "img_onboarding_3")!, text: "건국대학교 제휴식당을 한눈에!\n티어별로 확인해 보세요", highlightedText: "제휴식당"),
            OnboardingContent(image: UIImage(named: "img_onboarding_4")!, text: "건대생의 메뉴추천,\n쿠스토랑 뽑기로 정해 보세요!", highlightedText: "쿠스토랑 뽑기")
        ]
    }
}

class OnboardingView: UIView {
    
    private var logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo_home")?.resized(to: CGSize(width: 126, height: 33))
        return iv
    }()
    
    var onboardingCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    var pageControl: KuPageControl = {
        let pageControl = KuPageControl()
        pageControl.numberOfPages = 4
        pageControl.currentPage = 1
        return pageControl
    }()
    
    var socialLoginView: SocialLoginView = {
        let view = SocialLoginView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OnboardingView {
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(logoImageView, autoLayout: [.topSafeArea(constant: 20), .leading(20)])
        addSubview(onboardingCollectionView, autoLayout: [.topNext(to: logoImageView, constant: 20), .leading(0), .trailing(0), .height(UIScreen.main.bounds.height * 0.56)])
        addSubview(pageControl, autoLayout: [.topNext(to: onboardingCollectionView, constant: 12), .leading(124), .trailing(124), .height(36)])
        addSubview(socialLoginView, autoLayout: [.topNext(to: pageControl, constant: 24), .leading(32), .trailing(32), .bottom(28)])
    }
}
