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
    
    // 마커와 오버레이 관리
    private var markers: [NMFMarker] = []
    private var polygons: [NMFPolygonOverlay] = []
    private var polylines: [NMFPolylineOverlay] = []
    
    enum Polygon {
        case solid, dashed
    }
    
    // MARK: - Initialization
    init(
        view: TierMapView,
        viewModel: TierMapViewModel
    ) {
        self.view = view
        self.viewModel = viewModel
        super.init()
        view.naverMapView.mapView.touchDelegate = self
    }
}

extension NMFMapViewHandler {
    func updateMap(_ data: TierMapRestaurants?) {
        guard let mapData = data else { return }
        clearMap()
        cameraUpdate(mapData.visibleBounds)
        addPolygonOverlay(type: .solid, mapData.solidPolygonCoordsList)
        addPolygonOverlay(type: .dashed, mapData.dashedPolygonCoordsList)
        addMarkersForRestaurants(tieredRestaurants: mapData.tieredRestaurants, nonTieredRestaurants: mapData.nonTieredRestaurants)
    }
    
    private func clearMap() {
        // 기존 마커 제거
        markers.forEach { $0.mapView = nil }
        markers.removeAll()
        
        // 기존 폴리곤 제거
        polygons.forEach { $0.mapView = nil }
        polygons.removeAll()
        
        // 기존 폴리라인 제거
        polylines.forEach { $0.mapView = nil }
        polylines.removeAll()
    }

    // MARK: 마커
    private func addMarkersForRestaurants(
        tieredRestaurants: [Restaurant?]?,
        nonTieredRestaurants: [TierMapRestaurants.NonTieredRestaurants?]?
    ) {
        if let tieredRestaurants = tieredRestaurants?.compactMap({ $0 }) {
            for restaurant in tieredRestaurants {
                addMarker(for: restaurant, isFavorite: restaurant.isFavorite ?? false, zoom: nil)
            }
        }
        
        if let nonTieredRestaurants = nonTieredRestaurants?.compactMap({ $0 }) {
            for nonRestaurants in nonTieredRestaurants {
                guard let restaurants = nonRestaurants.restaurants?.compactMap({ $0 }) else { continue }
                let zoom = nonRestaurants.zoom
                for restaurant in restaurants {
                    addMarker(for: restaurant, isFavorite: restaurant.isFavorite ?? false, zoom: zoom)
                }
            }
        }
    }
    
    private func addMarker(
        for restaurant: Restaurant,
        isFavorite: Bool,
        zoom: Int?
    ) {
        guard 
            let lat = Double(restaurant.y ?? ""),
            let lng = Double(restaurant.x ?? "")
        else { return }

        let coords = NMGLatLng(lat: lat, lng: lng)
        let marker = NMFMarker(position: coords)
        var iconSize: CGSize = CGSize(width: 30, height: 30)
        
        if isFavorite {
            iconSize = CGSize(width: 19, height: 19)
            if let markerIcon = UIImage(named: "icon_favorite")?.resized(to: iconSize) {
                marker.iconImage = NMFOverlayImage(image: markerIcon)
            }
            marker.zIndex = 100
            
        } else {
            if let zoom = zoom {
                marker.isMinZoomInclusive = true
                marker.minZoom = Double(zoom)
            }

            if let tier = restaurant.mainTier {
                if tier == .unowned {
                    iconSize = CGSize(width: 12, height: 16)
                }
                if let markerIcon = UIImage(named: restaurant.mainTier?.iconImageName ?? "")?.resized(to: iconSize) {
                    marker.iconImage = NMFOverlayImage(image: markerIcon)
                }
                marker.zIndex = tier.zIndex
            }
        }
        marker.mapView = view.naverMapView.mapView
        
        markers.append(marker)
    }

    // MARK: 카메라
    private func cameraUpdate(_ bounds: [CGFloat?]?) {
        guard
            let bounds = bounds?.compactMap({ $0 }).map({ Double($0 )}),
            bounds.count >= 4
        else { return }
        let visibleBounds = NMGLatLngBounds(
            southWestLat: bounds[2],
            southWestLng: bounds[0],
            northEastLat: bounds[3],
            northEastLng: bounds[1]
        )
        let cameraUpdate = NMFCameraUpdate(fit: visibleBounds, padding: 0)
        cameraUpdate.animation = .fly
        view.naverMapView.mapView.moveCamera(cameraUpdate)
    }
    
    // MARK: 영역
    private func addPolygonOverlay(
        type: Polygon,
        _ polygonCoordsList: [[Coords?]?]?
    ) {
        guard let polygonCoordsList = polygonCoordsList else { return }
                
        for coordsList in polygonCoordsList {
            guard let coordsList = coordsList else { continue }
            let coords = coordsList.compactMap { $0 }
            guard !coords.isEmpty else { continue }
            
            let nmgLatLngs = coords.map({$0.nmgLatLng})

            let polygonOverlay = NMFPolygonOverlay(nmgLatLngs)
            polygonOverlay?.fillColor = (type == .solid) ? .mapSolidBackground : .mapDashedBackground
            
            switch type {
            case .solid:
                polygonOverlay?.outlineColor = .mapOutline
                polygonOverlay?.outlineWidth = 2
            case .dashed:
                addDashedPolylineOverlay(coords: nmgLatLngs)
            }
            
            polygonOverlay?.mapView = view.naverMapView.mapView
            
            if let overlay = polygonOverlay {
                polygons.append(overlay)
            }

        }
    }
    
    private func addDashedPolylineOverlay(coords: [NMGLatLng]) {
        let polylineOverlay = NMFPolylineOverlay(coords + [coords.first!]) // 닫힌 다각형
        polylineOverlay?.pattern = [5, 5]
        polylineOverlay?.color = .mapOutline
        polylineOverlay?.capType = .butt
        polylineOverlay?.width = 2
        polylineOverlay?.mapView = view.naverMapView.mapView
        
        if let overlay = polylineOverlay {
            polylines.append(overlay)
        }
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
        return true
    }
}
