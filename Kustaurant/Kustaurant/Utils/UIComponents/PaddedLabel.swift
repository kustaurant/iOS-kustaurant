//
//  PaddedLabel.swift
//  Kustaurant
//
//  Created by 송우진 on 7/30/24.
//

import UIKit

final class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets.zero { didSet { setNeedsDisplay() } }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}

