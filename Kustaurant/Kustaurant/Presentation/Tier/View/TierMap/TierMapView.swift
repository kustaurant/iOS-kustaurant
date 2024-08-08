//
//  TierMapView.swift
//  Kustaurant
//
//  Created by 송우진 on 8/8/24.
//

import UIKit
import NMapsMap

final class TierMapView: UIView {
    let naverMapView = NMFMapView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TierMapView {
    private func setup() {
        addSubview(naverMapView, autoLayout: [.fill(0)])
        
        configureNaverMap()
    }
    
    private func configureNaverMap() {
        naverMapView.isIndoorMapEnabled = true // 실내지도를 활성화
    }
}
