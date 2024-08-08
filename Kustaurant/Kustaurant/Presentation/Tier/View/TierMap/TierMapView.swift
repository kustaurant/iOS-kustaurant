//
//  TierMapView.swift
//  Kustaurant
//
//  Created by 송우진 on 8/8/24.
//

import UIKit
import NMapsMap

final class TierMapView: UIView {
    let naverMapView = NMFNaverMapView()
    
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
        naverMapView.showLocationButton = true // 현 위치 버튼이 활성화되어 있는지 여부.
        naverMapView.mapView.isIndoorMapEnabled = true // 실내지도를 활성화
        naverMapView.mapView.positionMode = .direction // 위치 추적 모드를 나타내는 열거형.

        // 초기 위치 및 줌 레벨 설정 (건국대학교 좌표 및 줌 레벨 14)
        let cameraUpdate = NMFCameraUpdate(scrollTo: KuCoords.kku, zoomTo: 14.0)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1.5
        naverMapView.mapView.moveCamera(cameraUpdate)
    }
}
