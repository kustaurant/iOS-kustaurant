//
//  DefaultTableViewCell.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {
    func loadImage(
        urlString: String?,
        targetSize: CGSize?
    ) async -> UIImage? {
        guard let urlString,
              let url = URL(string: urlString)
        else { return nil }
        let image = await ImageCacheManager.shared.loadImage(from: url, targetSize: targetSize)
        return image
    }
}
