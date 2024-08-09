//
//  Coords.swift
//  Kustaurant
//
//  Created by 송우진 on 8/8/24.
//

import NMapsMap

struct Coords: Codable {
    var x: CGFloat?
    var y: CGFloat?
}

extension Coords {
    var nmgLatLng: NMGLatLng {
        NMGLatLng(lat: Double(x ?? 0), lng: Double(y ?? 0))
    }
}
