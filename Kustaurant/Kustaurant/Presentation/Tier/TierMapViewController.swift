//
//  TierMapViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import UIKit
import NMapsMap
 

final class TierMapViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        
        let mapView = NMFMapView(frame: view.bounds)
        view.addSubview(mapView)
    }
}
