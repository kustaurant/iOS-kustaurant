//
//  NMFMapCameraManager.swift
//  Kustaurant
//
//  Created by 송우진 on 8/22/24.
//

import NMapsMap

final class NMFMapCameraManager {
    private var view: TierMapView
    
    // MARK: - Initialization
    init(view: TierMapView) {
        self.view = view
    }
}

extension NMFMapCameraManager {
    func cameraUpdate(_ bounds: [CGFloat?]?) {
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
}
