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
        ImageCacheManager.shared.loadImage(
            from: url,
            targetWidth: contentView.bounds.width,
            defaultImage: nil) { [weak self] image in
                Task {
                    await MainActor.run {
                        self?.imageView.image = image
                    }
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
