//
//  TierMapView.swift
//  Kustaurant
//
//  Created by 송우진 on 8/8/24.
//

import UIKit
import NMapsMap

final class TierMapView: UIView, TierBaseView {
    let naverMapView = NMFNaverMapView()
    let topCategoriesView = TierTopCategoriesView()
    
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
        addSubview(topCategoriesView, autoLayout: [.topSafeArea(constant: 18), .fillX(0), .height(Category.height)])
        configureNaverMap()
    }
    
    private func configureNaverMap() {
        naverMapView.showLocationButton = true // 현 위치 버튼이 활성화되어 있는지 여부.
        naverMapView.mapView.isIndoorMapEnabled = true // 실내지도를 활성화
        naverMapView.mapView.positionMode = .direction // 위치 추적 모드를 나타내는 열거형.
        // 첫 지도 위치를 건국대학교로 지정
        let bounds = NMGLatLngBounds(southWestLat: 37.5358341, southWestLng: 127.062852, northEastLat: 37.5482696, northEastLng: 127.0876883)
        let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: 0)
        naverMapView.mapView.moveCamera(cameraUpdate)
    }

}
