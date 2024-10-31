//
//  ImageCacheManager.swift
//  Kustaurant
//
//  Created by 송우진 on 7/19/24.
//

import UIKit

public class ImageCacheManager {
    public static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()

    private init() {
        let memoryCapacity = ProcessInfo.processInfo.physicalMemory
        let cacheLimit = min(Int(memoryCapacity / 100), 100 * 1024 * 1024)
        cache.totalCostLimit = cacheLimit
        cache.evictsObjectsWithDiscardedContent = true
    }

    
    public func loadImage(
        from url: URL,
        targetSize: CGSize? = nil,
        defaultImage: UIImage? = nil
    ) async -> UIImage? {
        let cacheKey = url.absoluteString as NSString
        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return defaultImage }

            var resizedImage: UIImage? = image
            if let targetSize {
                resizedImage = image.resized(to: targetSize)
            }

            if let resizedImage = resizedImage,
               let imageData = resizedImage.pngData()
            {
                let cost = imageData.count
                cache.setObject(resizedImage, forKey: cacheKey, cost: cost)
            }
            return resizedImage
        } catch {
            return defaultImage
        }
    }
}
