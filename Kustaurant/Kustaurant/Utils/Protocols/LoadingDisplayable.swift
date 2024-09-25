//
//  LoadingDisplayable.swift
//  Kustaurant
//
//  Created by 송우진 on 9/24/24.
//

import UIKit

protocol LoadingDisplayable {}

extension LoadingDisplayable where Self: UIViewController {
    func showLoadingView() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard windowScene?.windows.first?.viewWithTag(999) == nil,
              let window = windowScene?.windows.first
        else { return }

        Task { @MainActor in
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.center = window.center
            
            let backgroundView = UIView(frame: window.bounds)
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            backgroundView.tag = 999
            backgroundView.addSubview(spinner)

            window.addSubview(backgroundView)
            spinner.startAnimating()
        }
    }
    
    func hideLoadingView() {
        Task { @MainActor in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first,
                  let loadingView = window.viewWithTag(999)
            else { return }
            
            loadingView.removeFromSuperview()
        }
    }
}
