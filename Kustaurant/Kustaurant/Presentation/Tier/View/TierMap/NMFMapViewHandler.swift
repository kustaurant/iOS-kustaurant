//
//  NMFMapViewHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 8/8/24.
//

import NMapsMap
import UIKit

final class NMFMapViewHandler: NSObject {
    private var view: TierMapView
    private var viewModel: TierMapViewModel
    
    private var markerManager: NMFMapMarkerManager
    private var polygonManager: NMFMapPolygonManager
    private var cameraManager: NMFMapCameraManager
    
    // MARK: - Initialization
    init(
        view: TierMapView,
        viewModel: TierMapViewModel
    ) {
        self.view = view
        self.viewModel = viewModel
        markerManager = NMFMapMarkerManager(view: view, viewModel: viewModel)
        polygonManager = NMFMapPolygonManager(view: view)
        cameraManager = NMFMapCameraManager(view: view)
        super.init()
        view.naverMapView.mapView.touchDelegate = self
    }
}

extension NMFMapViewHandler {
    func updateMap(_ data: TierMapRestaurants?) {
        guard let mapData = data else { return }
        clearMap()
        cameraManager.cameraUpdate(mapData.visibleBounds)
        polygonManager.addPolygonOverlay(type: .solid, mapData.solidPolygonCoordsList)
        polygonManager.addPolygonOverlay(type: .dashed, mapData.dashedPolygonCoordsList)
        markerManager.addMarkersForRestaurants(
            tieredRestaurants: mapData.tieredRestaurants,
            nonTieredRestaurants: mapData.nonTieredRestaurants
        )
    }
    
    func resetSelectedMarker() {
        markerManager.resetSelectedMarker()
    }
}

extension NMFMapViewHandler {
    private func clearMap() {
        markerManager.clearMarkers()
        polygonManager.clearPolygons()
    }
}


// MARK: - NMFMapViewTouchDelegate
extension NMFMapViewHandler: NMFMapViewTouchDelegate {
    /*
     https://navermaps.github.io/ios-map-sdk/reference/Protocols/NMFMapViewTouchDelegate.html#/c:objc(pl)NMFMapViewTouchDelegate(im)mapView:didTapSymbol:
     */
    
    /// 지도가 탭되면 호출되는 콜백 메서드.
    /// - Parameters:
    ///   - latlng: 탭된 지점의 지도 좌표.
    ///   - point: 탭된 지점의 화면 좌표.
    func mapView(
        _ mapView: NMFMapView,
        didTapMap latlng: NMGLatLng,
        point: CGPoint
    ) {
        #if DEBUG
        print("\(latlng.lat), \(latlng.lng)")
        #endif
        resetSelectedMarker()
        viewModel.didTapMap()
    }
    
    /// 지도 심벌이 탭되면 호출되는 콜백 메서드.
    /// - Parameters:
    ///   - mapView: 지도 객체.
    ///   - symbol: 탭된 심벌.
    /// - Returns: YES일 경우 이벤트를 소비합니다. 그렇지 않을 경우 이벤트가 지도로 전달되어 mapView:didTapMap:point:가 호출됩니다.
    func mapView(
        _ mapView: NMFMapView,
        didTap symbol: NMFSymbol
    ) -> Bool {
        #if DEBUG
        print(symbol.caption!)
        #endif
        resetSelectedMarker()
        viewModel.didTapMap()
        return true
    }
}
