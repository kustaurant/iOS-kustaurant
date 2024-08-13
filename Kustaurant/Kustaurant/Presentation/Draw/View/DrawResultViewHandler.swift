//
//  DrawResultRouletteHandler.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/12/24.
//

import UIKit

final class DrawResultViewHandler {
    
    static let rouletteAnimationDurationSeconds: Double = 4.0
    static let rouletteCount = 30
    
    private let view: DrawResultView
    private let viewModel: DrawResultViewModel
    
    init(view: DrawResultView, viewModel: DrawResultViewModel) {
        self.view = view
        self.viewModel = viewModel
    }
}

// View
extension DrawResultViewHandler {
    
    func configureRestaurantLabels(with restaurant: Restaurant?) {
        view.categoryLabel.text = restaurant?.restaurantCuisine
        view.restaurantNameLabel.text = restaurant?.restaurantName
        view.partinerShipLabel.text = restaurant?.partnershipInfo
    }
    
    func showLoadingIndicator() {
        view.categoryLabel.isHidden = true
        view.restaurantNameLabel.isHidden = true
        view.ratingsView.isHidden = true
        view.partinerShipLabel.isHidden = true
        view.loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        view.loadingIndicator.stopAnimating()
        view.categoryLabel.isHidden = false
        view.restaurantNameLabel.isHidden = false
        view.ratingsView.isHidden = false
        view.partinerShipLabel.isHidden = false
    }
}

// Roulette
extension DrawResultViewHandler {
    
    func resetRoulettes() {
        view.drawedRestaurantImageView.alpha = 0
        view.rouletteStackView.arrangedSubviews.forEach {
            $0.backgroundColor = .clear
        }
        view.rouletteScrollView.contentOffset.x = 0
    }
    
    func updateRestaurantRouletteView(restaurants: [Restaurant]) {
        guard restaurants.count > 0 else { return }
        view.rouletteStackView.arrangedSubviews.enumerated().forEach { (idx, view) in
            let restaurant = restaurants[idx]
            guard
                let iv = view as? UIImageView,
                let imgUrlString = restaurant.restaurantImgUrl,
                let imgUrl = URL(string: imgUrlString)
            else {
                print("❗️ Fail to Load Restaurant Image at: \(String(describing: restaurant.restaurantName))")
                return
            }
            
            // TODO: restuarntImgUrl이 no_img 인 경우 예외처리
            if restaurant.restaurantImgUrl == "no_img" {
                iv.image = UIImage(named: "icon_ku")
                return
            }
            
            ImageCacheManager.shared.loadImage(from: imgUrl, targetWidth: iv.bounds.width) { image in
                iv.image = image
                if idx == DrawResultViewHandler.rouletteCount - 1 {
                    self.view.drawedRestaurantImageView.image = image
                }
            }
        }
    }
    
    func scrollToLastRestaurant() {
        guard let lastViewX = view.rouletteStackView.arrangedSubviews.last?.frame.origin.x else { return }
        UIView.animate(withDuration: Self.rouletteAnimationDurationSeconds, delay: 0, options: [.curveEaseOut], animations: {
            self.view.rouletteScrollView.contentOffset.x = lastViewX
        }, completion: { [weak self] _ in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut]) { [weak self] in
                self?.view.drawedRestaurantImageView.alpha = 1
            }
        })
    }
}
