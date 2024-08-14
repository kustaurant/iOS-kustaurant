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
    
    private var timer: Timer?
    private var restaurantIndex = 0
    
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
    
    func resetRestaurantLabels() {
        view.categoryLabel.text = ""
        view.restaurantNameLabel.text = ""
        view.partinerShipLabel.text = ""
    }
    
    func startRestaurantNameAnimation(with restaurants: [Restaurant]) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.view.restaurantNameLabel.text = restaurants[self.restaurantIndex].restaurantName
            self.restaurantIndex = (self.restaurantIndex + 1) % restaurants.count
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.rouletteAnimationDurationSeconds - 0.1) { [weak self] in
            self?.configureRestaurantLabels(with: restaurants.last)
            self?.restaurantIndex = 0
            self?.timer?.invalidate()
            self?.timer = nil
        }
    }
}

// Roulette
extension DrawResultViewHandler {
    
    func resetRoulettes() {
        view.drawedRestaurantImageView.alpha = 0
        view.rouletteScrollView.contentOffset.x = 0
    }
    
    func makeRoulettes(with restaurants: [Restaurant]) {
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
            
            let defaultImage = UIImage(named: "icon_ku")
            
            ImageCacheManager.shared.loadImage(from: imgUrl, targetWidth: iv.bounds.width, defaultImage: defaultImage) { image in
                iv.image = image
                if idx == DrawResultViewHandler.rouletteCount - 1 {
                    self.view.drawedRestaurantImageView.image = image
                }
            }
        }
    }
    
    func startRouletteScrollAnimation() {
        guard let lastViewX = view.rouletteStackView.arrangedSubviews.last?.frame.origin.x else { return }
        UIView.animate(withDuration: Self.rouletteAnimationDurationSeconds, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            self?.view.rouletteScrollView.contentOffset.x = lastViewX
        })
    }
    
    func showDrawedRestaurantImage() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut]) { [weak self] in
            self?.view.drawedRestaurantImageView.alpha = 1
        }
    }
}
