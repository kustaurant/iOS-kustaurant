//
//  LoadingDisplayable.swift
//  Kustaurant
//
//  Created by 송우진 on 9/24/24.
//

import UIKit
import Lottie

protocol LoadingDisplayable {}

extension LoadingDisplayable where Self: UIViewController {
    func showLoadingView(isBlocking: Bool = true) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first })
            .first(where: { $0.isKeyWindow })
        else { return }

        guard window.viewWithTag(999) == nil else { return }
        
        Task { @MainActor in
            let spinner = LottieAnimationView(name: "lottie-loading")
            spinner.loopMode = .loop
            spinner.frame = window.bounds
            spinner.contentMode = .scaleAspectFill
            spinner.tag = 999
            spinner.play()

            if isBlocking {
                let backgroundView = UIView(frame: window.bounds)
                backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                backgroundView.tag = 998
                backgroundView.addSubview(spinner, autoLayout: [.center(0), .width(100), .height(100)])
                window.addSubview(backgroundView)
            } else {
                window.addSubview(spinner, autoLayout: [.center(0), .width(100), .height(100)])
            }
        }
    }
    
    func hideLoadingView() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first })
            .first(where: { $0.isKeyWindow })
        else { return }
        Task { @MainActor in
            window.viewWithTag(999)?.removeFromSuperview()
            window.viewWithTag(998)?.removeFromSuperview()
        }
    }
}
