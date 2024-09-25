//
//  Alertable.swift
//  Kustaurant
//
//  Created by 송우진 on 9/25/24.
//

import UIKit

protocol Alertable {}

extension Alertable where Self: UIViewController {
    func showAlert(
        title: String = "",
        message: String,
        preferredStyle: UIAlertController.Style = .alert,
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: completion)
    }
}
