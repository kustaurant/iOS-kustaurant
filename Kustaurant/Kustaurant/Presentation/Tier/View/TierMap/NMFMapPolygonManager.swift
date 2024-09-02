//
//  NMFMapPolygonManager.swift
//  Kustaurant
//
//  Created by 송우진 on 8/22/24.
//

import NMapsMap

final class NMFMapPolygonManager {
    enum Polygon {
        case solid, dashed
    }
    
    private var view: TierMapView
    
    private var polygons: [NMFPolygonOverlay] = []
    private var polylines: [NMFPolylineOverlay] = []
    
    // MARK: - Initialization
    init(view: TierMapView) {
        self.view = view
    }
}

extension NMFMapPolygonManager {
    func addPolygonOverlay(
        type: Polygon,
        _ polygonCoordsList: [[Coords?]?]?
    ) {
        guard let validCoordsList = getValidCoordsList(from: polygonCoordsList) else { return }

        for coords in validCoordsList {
            let nmgLatLngs = coords.map { $0.nmgLatLng }
            addPolygon(type: type, nmgLatLngs: nmgLatLngs)
        }
    }
    
    func clearPolygons() {
        polygons.forEach { $0.mapView = nil }
        polygons.removeAll()
        
        polylines.forEach { $0.mapView = nil }
        polylines.removeAll()
    }
}

extension NMFMapPolygonManager {
    // 유효한 좌표 리스트 필터링
    private func getValidCoordsList(from polygonCoordsList: [[Coords?]?]?) -> [[Coords]]? {
        polygonCoordsList?.compactMap { coordsList in
            coordsList?.compactMap { $0 }
        }.filter { !$0.isEmpty }
    }

    private func addPolygon(
        type: Polygon,
        nmgLatLngs: [NMGLatLng]
    ) {
        guard let polygonOverlay = NMFPolygonOverlay(nmgLatLngs) else { return }
        polygonOverlay.fillColor = (type == .solid) ? .mapSolidBackground : .mapDashedBackground
        switch type {
        case .solid:
            polygonOverlay.outlineColor = .mapOutline
            polygonOverlay.outlineWidth = 2
        case .dashed:
            addDashedPolylineOverlay(coords: nmgLatLngs)
        }
        polygonOverlay.mapView = view.naverMapView.mapView
        polygons.append(polygonOverlay)
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
