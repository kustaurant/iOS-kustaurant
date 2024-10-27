//
//  HomeBannerCollectionViewCell.swift
//  Kustaurant
//
//  Created by 송우진 on 8/17/24.
//

import UIKit

final class HomeBannerCollectionViewCell: UICollectionViewCell, ReusableCell {
    static var reuseIdentifier: String = String(describing: HomeBannerCollectionViewCell.self)

    var banner: String? { didSet {bind()} }
    private let imageView = UIImageView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeBannerCollectionViewCell {
    private func bind() {
        guard let banner = banner,
              let url = URL(string: banner)
        else { return }
        
        loadImage(url: url)
    }
    
    private func loadImage(url: URL) {
        Task {
            let image = await ImageCacheManager.shared.loadImage(
                from: url,
                targetSize: contentView.bounds.size
            )
            await MainActor.run {
                UIView.transition(
                    with: imageView,
                    duration: 0.25,
                    options: .transitionCrossDissolve,
                    animations: {
                        self.imageView.image = image
                    },
                    completion: nil
                )
            }
        }
    }
}

extension HomeBannerCollectionViewCell {
    private func setup() {
        addSubviews()
        configureImageView()
    }
    
    private func addSubviews() {
        contentView.addSubview(imageView, autoLayout: [.fill(0)])
    }
    
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
