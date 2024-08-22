//
//  NMFMapMarkerManager.swift
//  Kustaurant
//
//  Created by 송우진 on 8/22/24.
//

import NMapsMap

final class NMFMapMarkerManager {
    private var view: TierMapView
    private var viewModel: TierMapViewModel
    private var markers: [NMFMarker] = []
    private var selectedMarker: (NMFMarker, Restaurant)?
    
    // MARK: - Initialization
    init(
        view: TierMapView,
        viewModel: TierMapViewModel
    ) {
        self.view = view
        self.viewModel = viewModel
    }
}

extension NMFMapMarkerManager {
    func addMarkersForRestaurants(
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
    
    func clearMarkers() {
        markers.forEach { $0.mapView = nil }
        markers.removeAll()
    }
}

extension NMFMapMarkerManager {
    private func addMarker(
        for restaurant: Restaurant,
        isFavorite: Bool,
        zoom: Int?
    ) {
        guard let coords = getCoords(for: restaurant) else { return }
        
        let marker = NMFMarker(position: coords)
        configureMarkerAppearance(marker, for: restaurant, isFavorite: isFavorite, zoom: zoom)
        setupMarkerTouchHandler(marker, for: restaurant)

        marker.mapView = view.naverMapView.mapView
        markers.append(marker)
    }

    private func getCoords(for restaurant: Restaurant) -> NMGLatLng? {
        guard
            let lat = Double(restaurant.y ?? ""),
            let lng = Double(restaurant.x ?? "")
        else { return nil }
        
        return NMGLatLng(lat: lat, lng: lng)
    }

    private func getMarkerIcon(named: String, size: CGSize) -> NMFOverlayImage? {
        guard let markerIcon = UIImage(named: named)?.resized(to: size) else { return nil }
        return NMFOverlayImage(image: markerIcon)
    }

    private func setupMarkerTouchHandler(_ marker: NMFMarker, for restaurant: Restaurant) {
        marker.userInfo = ["restaurant": restaurant]
        marker.touchHandler = { [weak self] _ in
            guard let restaurant = marker.userInfo["restaurant"] as? Restaurant else { return true }
            // 이전 선택된 마커의 보더 제거
            if let previousMarker = self?.selectedMarker {
                self?.resetMarkerAppearance(previousMarker)
            }
            
            // 선택된 마커에 보더 추가
            self?.selectedMarker = (marker, restaurant)
            self?.configureBorderedMarkerAppearance(marker, for: restaurant)

            // ViewModel에 마커 클릭 알림 전달
            self?.viewModel.didTapMarker(restaurant: restaurant)

            return true
        }
    }

    private func configureMarkerAppearance(
        _ marker: NMFMarker,
        for restaurant: Restaurant,
        isFavorite: Bool,
        zoom: Int?
    ) {
        var iconSize: CGSize
        if restaurant.mainTier == .unowned {
            iconSize = CGSize(width: 12, height: 16)
        } else {
            iconSize = isFavorite ? CGSize(width: 19, height: 19) : CGSize(width: 30, height: 30)
        }

        let iconName = isFavorite ? "icon_favorite" : restaurant.mainTier?.iconImageName ?? ""

        if let iconImage = getMarkerIcon(named: iconName, size: iconSize) {
            marker.iconImage = iconImage
            marker.zIndex = isFavorite ? 100 : restaurant.mainTier?.zIndex ?? 0
        }

        if let zoom = zoom {
            marker.isMinZoomInclusive = true
            marker.minZoom = Double(zoom)
        }
    }

    private func configureBorderedMarkerAppearance(
        _ marker: NMFMarker,
        for restaurant: Restaurant)
    {
        var iconSize: CGSize
        if restaurant.mainTier == .unowned {
            iconSize = CGSize(width: 18, height: 24)
        } else {
            iconSize = restaurant.isFavorite ?? false ? CGSize(width: 25, height: 25) : CGSize(width: 36, height: 36)
        }
        
        let iconName = restaurant.isFavorite ?? false ? "icon_favorite" : restaurant.mainTier?.iconImageName ?? ""
        
        if let iconImage = UIImage(named: iconName)?.resizedWithBorder(to: iconSize, borderWidth: 3, cornerRadius: 10) {
            marker.iconImage = NMFOverlayImage(image: iconImage)
        }
    }

    // 기본 상태로 복원
    private func resetMarkerAppearance(_ marker: (NMFMarker, Restaurant)) {
        configureMarkerAppearance(marker.0, for: marker.1, isFavorite: marker.1.isFavorite ?? false, zoom: nil)
    }
}


private extension UIImage {
    func resizedWithBorder(to size: CGSize, borderWidth: CGFloat, cornerRadius: CGFloat) -> UIImage? {
        let imageRect = CGRect(
            origin: CGPoint(x: borderWidth, y: borderWidth),
            size: CGSize(width: size.width - 2 * borderWidth, height: size.height - 2 * borderWidth)
        )

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        let borderRect = CGRect(origin: .zero, size: size)
        let context = UIGraphicsGetCurrentContext()

        let path = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadius)
        context?.setFillColor(UIColor.black.cgColor)
        context?.addPath(path.cgPath)
        context?.fillPath()

        let clippingPath = UIBezierPath(roundedRect: imageRect, cornerRadius: cornerRadius - borderWidth)
        clippingPath.addClip()
        self.draw(in: imageRect)

        let imageWithBorder = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageWithBorder
    }
}
