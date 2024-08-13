//
//  DrawResultRouletteHandler.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/12/24.
//

import UIKit

final class DrawResultRouletteHandler {
    
    private let view: DrawResultView
    private let viewModel: DrawResultViewModel
    
    init(view: DrawResultView, viewModel: DrawResultViewModel) {
        self.view = view
        self.viewModel = viewModel
    }
}

extension DrawResultRouletteHandler {
    
    func resetRoulettes() {
        view.drawedRestaurantImageView.alpha = 0
        view.rouletteStackView.arrangedSubviews.forEach {
            $0.backgroundColor = .clear
        }
        view.rouletteScrollView.contentOffset.x = 0
    }
    
    func updateRestaurantRouletteView(restaurants: [UIColor]) {
        view.rouletteStackView.arrangedSubviews.enumerated().forEach { (idx, view) in
            view.backgroundColor = restaurants[idx]
            if idx == DrawResultView.roulettesCount - 1 {
                self.view.drawedRestaurantImageView.backgroundColor = restaurants[idx]
            }
        }
    }
    
    func scrollToLastRestaurant() {
        guard let lastViewX = view.rouletteStackView.arrangedSubviews.last?.frame.origin.x else { return }
        UIView.animate(withDuration: 4.0, delay: 0, options: [.curveEaseOut], animations: {
            self.view.rouletteScrollView.contentOffset.x = lastViewX
        }, completion: { [weak self] _ in
            UIView.animate(withDuration: 0.5, delay: 0.3, options: [.curveEaseOut]) { [weak self] in
                self?.view.drawedRestaurantImageView.alpha = 1
            }
        })
    }
}
