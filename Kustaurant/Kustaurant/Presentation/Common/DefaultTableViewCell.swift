//
//  DefaultTableViewCell.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {
    func loadImage(
        _ imageView: UIImageView,
        urlString: String?,
        targetSize: CGSize?
    ) async {
        guard let urlString,
              let url = URL(string: urlString)
        else { return }
        let image = await ImageCacheManager.shared.loadImage(from: url, targetSize: targetSize)
        await MainActor.run {
            imageView.image = image
        }
    }
}
