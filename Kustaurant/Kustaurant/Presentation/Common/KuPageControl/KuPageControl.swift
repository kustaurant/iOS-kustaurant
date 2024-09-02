//
//  KuPageControl.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/7/24.
//

import UIKit
import Combine

protocol KuPageControlDelegate: AnyObject {
    func didTapIndicator(at: Int)
}

class KuPageControl: UIView {
    
    weak var delegate: KuPageControlDelegate?

    var numberOfPages: Int = 0 {
        didSet {
            setupIndicators()
        }
    }
    
    @Published var currentPage: Int = 0 {
        didSet {
            updateIndicators()
        }
    }
    
    private let selectedImage = UIImage(named: "icon_pagecontrol_selected")
    private let unselectedImage = UIImage(named: "icon_pagecontrol_unselected")
    
    private var indicators: [UIImageView] = []
    private var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupIndicators()
        setupBindings()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBindings() {
        $currentPage
            .sink { [weak self] _ in
                self?.updateIndicators()
            }
            .store(in: &cancellables)
    }
    
    private func setupIndicators() {
        indicators.forEach { $0.removeFromSuperview() }
        indicators = []
        
        for i in 0..<numberOfPages {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            imageView.addGestureRecognizer(tapGesture)
            imageView.tag = i
            
            indicators.append(imageView)
            addSubview(imageView)
        }
        
        setupConstraints()
        updateIndicators()
    }
    
    private func setupConstraints() {
        for (index, imageView) in indicators.enumerated() {
            addSubview(imageView, autoLayout: [.top(0), .bottom(0)])
            
            if index == 0 {
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            } else {
                imageView.leadingAnchor.constraint(equalTo: indicators[index - 1].trailingAnchor).isActive = true
            }
            
            if index == indicators.count - 1 {
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            }
        }
    }
    
    private func updateIndicators() {
        for (index, imageView) in indicators.enumerated() {
            imageView.image = (index == currentPage) ? selectedImage : unselectedImage
        }
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        currentPage = tappedView.tag
        delegate?.didTapIndicator(at: tappedView.tag)
    }
}
