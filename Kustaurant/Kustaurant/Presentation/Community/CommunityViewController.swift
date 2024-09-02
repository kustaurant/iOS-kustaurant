//
//  CommunityViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class CommunityViewController: UIViewController {
    private let imgView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        imgView.image = UIImage(named: "img_preparing")
        view.addSubview(imgView, autoLayout: [.center(0)])
    }
}
