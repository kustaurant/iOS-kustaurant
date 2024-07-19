//
//  UIFont.swift
//  Kustaurant
//
//  Created by 송우진 on 7/19/24.
//

import UIKit

extension UIFont {
    static func pretendard(
        size fontSize: CGFloat,
        weight: UIFont.Weight
    ) -> UIFont {
        var weightString: String
        switch weight {
        case .black: weightString = "Black"
        case .bold: weightString = "Blod"
        case .heavy: weightString = "ExtraBold"
        case .ultraLight: weightString = "ExtraLight"
        case .light: weightString = "Light"
        case .medium: weightString = "Medium"
        case .regular: weightString = "Regular"
        case .semibold: weightString = "SemiBold"
        case .thin: weightString = "Thin"
        default: weightString = "Regular"
        }

        return UIFont(name: "Pretendard-\(weightString)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: weight)
    }
}
