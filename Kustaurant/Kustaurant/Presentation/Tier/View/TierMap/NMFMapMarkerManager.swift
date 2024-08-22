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
        configureMarker(marker, for: restaurant, isFavorite: isFavorite, zoom: zoom)
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
    
    private func configureMarker(
        _ marker: NMFMarker,
        for restaurant: Restaurant,
        isFavorite: Bool,
        zoom: Int?
    ) {
        var iconSize: CGSize = CGSize(width: 30, height: 30)
        
        if isFavorite {
            iconSize = CGSize(width: 19, height: 19)
            if let iconImage = getMarkerIcon(named: "icon_favorite", size: iconSize) {
                marker.iconImage = iconImage
                marker.zIndex = 100
            }
        } else {
            configureMarkerForNonFavorite(marker, restaurant: restaurant, zoom: zoom)
        }
    }

    private func configureMarkerForNonFavorite(
        _ marker: NMFMarker,
        restaurant: Restaurant,
        zoom: Int?
    ) {
        if let zoom = zoom {
            marker.isMinZoomInclusive = true
            marker.minZoom = Double(zoom)
        }

        if let tier = restaurant.mainTier {
            var iconSize = CGSize(width: 30, height: 30)
            if tier == .unowned {
                iconSize = CGSize(width: 12, height: 16)
            }
            if let iconImage = getMarkerIcon(named: restaurant.mainTier?.iconImageName ?? "", size: iconSize) {
                marker.iconImage = iconImage
                marker.zIndex = tier.zIndex
            }
        }
    }

    private func getMarkerIcon(
        named: String,
        size: CGSize
    ) -> NMFOverlayImage? {
        guard let markerIcon = UIImage(named: named)?.resized(to: size) else { return nil }
        return NMFOverlayImage(image: markerIcon)
    }

    private func setupMarkerTouchHandler(
        _ marker: NMFMarker,
        for restaurant: Restaurant
    ) {
        marker.userInfo = ["restaurant": restaurant]
        marker.touchHandler = { [weak self] _ in
            if let restaurant = marker.userInfo["restaurant"] as? Restaurant {
                self?.viewModel.didTapMarker(restaurant: restaurant)
            }
            return true
        }
    }
}
