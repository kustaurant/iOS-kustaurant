//
//  UITextField+.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/30/24.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        self.leftViewMode = ViewMode.always
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
    }
}
