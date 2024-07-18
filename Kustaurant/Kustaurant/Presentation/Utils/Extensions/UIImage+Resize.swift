//
//  UIImage+Resize.swift
//  Kustaurant
//
//  Created by 송우진 on 7/17/24.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
